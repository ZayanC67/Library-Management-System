package servlet;

import dao.BookIssueDAO;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * SERVLET: IssueBookServlet
 * Handles book issue requests from students or librarian.
 * URL: /IssueBookServlet
 * Business Logic: Prevents issuing unavailable books, prevents duplicates.
 */
public class IssueBookServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session check (both student and librarian can issue)
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

        // If student is issuing, use their own USN from session
        if ("student".equals(role)) {
            usn = (String) session.getAttribute("usn");
        }

        // Validate inputs
        if (bookIdStr == null || bookIdStr.trim().isEmpty() || usn == null || usn.trim().isEmpty()) {
            session.setAttribute("error", "Book ID and USN are required.");
            redirectBack(response, request, role);
            return;
        }

        try {
            int bookId = Integer.parseInt(bookIdStr.trim());
            BookIssueDAO issueDAO = new BookIssueDAO();
            String result = issueDAO.issueBook(bookId, usn.trim());

            switch (result) {
                case "success":
                    session.setAttribute("success", "Book issued successfully! Issue Date: Today.");
                    break;
                case "not_available":
                    session.setAttribute("error", "Sorry, this book is currently not available.");
                    break;
                case "already_issued":
                    session.setAttribute("error", "This book is already issued to this student.");
                    break;
                default:
                    session.setAttribute("error", "An error occurred while issuing the book.");
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
            response.sendRedirect(request.getContextPath() + "/student/borrowBook.jsp");
        }
    }
}
