package servlet;

import dao.BookReturnDAO;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * SERVLET: ReturnBookServlet
 * Handles book return requests. Calculates fine automatically.
 * URL: /ReturnBookServlet
 */
public class ReturnBookServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session check
        HttpSession session = request.getSession(false);
        if (session == null || (session.getAttribute("student") == null && session.getAttribute("librarian") == null)) {
            String referer = request.getHeader("referer");
            if (referer != null && referer.contains("/librarian/")) {
                response.sendRedirect(request.getContextPath() + "/librarianLogin.jsp");
            } else {
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            }
            return;
        }

        String role      = (String) session.getAttribute("role");
        String bookIdStr = request.getParameter("bookId");
        String usn       = request.getParameter("usn");

        // If student is returning, use their session USN
        if ("student".equals(role)) {
            usn = (String) session.getAttribute("usn");
        }

        if (bookIdStr == null || bookIdStr.trim().isEmpty() || usn == null || usn.trim().isEmpty()) {
            session.setAttribute("error", "Book ID and USN are required.");
            redirectBack(response, request, role);
            return;
        }

        try {
            int bookId = Integer.parseInt(bookIdStr.trim());
            BookReturnDAO returnDAO = new BookReturnDAO();
            double fine = returnDAO.returnBook(bookId, usn.trim());

            if (fine == -1) {
                session.setAttribute("error", "No active issue record found for this book and student.");
            } else if (fine == 0) {
                session.setAttribute("success", "Book returned successfully! No fine applicable.");
            } else {
                session.setAttribute("success",
                    "Book returned successfully! Fine charged: Rs. " + String.format("%.2f", fine) +
                    " (Payment recorded automatically).");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid Book ID.");
        }

        redirectBack(response, request, role);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("role") : null;
        redirectBack(response, request, role);
    }

    private void redirectBack(HttpServletResponse response, HttpServletRequest request, String role)
            throws IOException {
        if ("librarian".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/librarian/librarianDashboard.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/student/returnBook.jsp");
        }
    }
}
