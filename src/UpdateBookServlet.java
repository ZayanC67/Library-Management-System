package servlet;

import dao.BookDAO;
import model.Book;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * SERVLET: UpdateBookServlet
 * Allows librarian to update book details.
 * URL: /UpdateBookServlet
 * Access: Librarian only
 */
public class UpdateBookServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("librarian") == null) {
            response.sendRedirect(request.getContextPath() + "/librarianLogin.jsp");
            return;
        }

        String bookIdStr  = request.getParameter("bookId");
        String bookName   = request.getParameter("bookName");
        String authorName = request.getParameter("authorName");
        String status     = request.getParameter("availabilityStatus");

        if (bookIdStr == null || bookIdStr.trim().isEmpty()
         || bookName == null || bookName.trim().isEmpty()
         || authorName == null || authorName.trim().isEmpty()) {
            session.setAttribute("error", "All fields are required to update a book.");
            response.sendRedirect(request.getContextPath() + "/librarian/manageBooks.jsp");
            return;
        }

        try {
            int bookId = Integer.parseInt(bookIdStr.trim());
            Book book = new Book();
            book.setBookId(bookId);
            book.setBookName(bookName.trim());
            book.setAuthorName(authorName.trim());
            book.setAvailabilityStatus(status != null ? status.trim() : "Available");

            BookDAO bookDAO = new BookDAO();
            boolean success = bookDAO.updateBook(book);

            if (success) {
                session.setAttribute("success", "Book updated successfully!");
            } else {
                session.setAttribute("error", "Book not found or update failed.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid Book ID.");
        }

        response.sendRedirect(request.getContextPath() + "/librarian/manageBooks.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/librarian/manageBooks.jsp");
    }
}
