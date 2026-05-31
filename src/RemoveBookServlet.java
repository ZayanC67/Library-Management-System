package servlet;

import dao.BookDAO;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * SERVLET: RemoveBookServlet
 * Allows librarian to remove a book from the library.
 * URL: /RemoveBookServlet
 * Access: Librarian only
 */
public class RemoveBookServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("librarian") == null) {
            response.sendRedirect(request.getContextPath() + "/librarianLogin.jsp");
            return;
        }

        String bookIdStr = request.getParameter("bookId");

        if (bookIdStr == null || bookIdStr.trim().isEmpty()) {
            session.setAttribute("error", "Book ID is required.");
            response.sendRedirect(request.getContextPath() + "/librarian/manageBooks.jsp");
            return;
        }

        try {
            int bookId = Integer.parseInt(bookIdStr.trim());
            BookDAO bookDAO = new BookDAO();
            boolean success = bookDAO.removeBook(bookId);

            if (success) {
                session.setAttribute("success", "Book removed successfully!");
            } else {
                session.setAttribute("error", "Book not found or could not be removed.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid Book ID format.");
        }

        response.sendRedirect(request.getContextPath() + "/librarian/manageBooks.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Handle GET request (direct delete via link)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("librarian") == null) {
            response.sendRedirect(request.getContextPath() + "/librarianLogin.jsp");
            return;
        }

        String bookIdStr = request.getParameter("bookId");
        if (bookIdStr != null && !bookIdStr.trim().isEmpty()) {
            try {
                int bookId = Integer.parseInt(bookIdStr.trim());
                BookDAO bookDAO = new BookDAO();
                boolean success = bookDAO.removeBook(bookId);
                if (success) {
                    session.setAttribute("success", "Book removed successfully!");
                } else {
                    session.setAttribute("error", "Book not found or could not be removed.");
                }
            } catch (NumberFormatException e) {
                session.setAttribute("error", "Invalid Book ID.");
            }
        }
        response.sendRedirect(request.getContextPath() + "/librarian/manageBooks.jsp");
    }
}
