package servlet;

import dao.BookRequestDAO;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class RequestBookServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("student") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String bookIdStr = request.getParameter("bookId");
        String usn = (String) session.getAttribute("usn");
        String redirect = request.getContextPath() + "/student/searchBook.jsp";
        if (request.getParameter("redirect") != null) {
            redirect = request.getContextPath() + request.getParameter("redirect");
        }

        if (bookIdStr == null || bookIdStr.trim().isEmpty()) {
            session.setAttribute("error", "Book selection is required to request a book.");
            response.sendRedirect(redirect);
            return;
        }

        try {
            int bookId = Integer.parseInt(bookIdStr.trim());
            BookRequestDAO requestDAO = new BookRequestDAO();
            String result = requestDAO.submitRequest(bookId, usn);

            switch (result) {
                case "success":
                    session.setAttribute("success", "Book request sent to the librarian. Please wait for approval.");
                    break;
                case "not_available":
                    session.setAttribute("error", "This book is not currently available for request.");
                    break;
                case "already_pending":
                    session.setAttribute("error", "You already have a pending request for this book.");
                    break;
                case "book_not_found":
                    session.setAttribute("error", "Book not found.");
                    break;
                default:
                    session.setAttribute("error", "Unable to submit the request at this time.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid book ID.");
        }
        response.sendRedirect(redirect);
    }
}
