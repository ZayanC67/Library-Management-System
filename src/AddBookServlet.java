package servlet;

import dao.BookDAO;
import model.Book;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * SERVLET: AddBookServlet
 * Allows librarian to add a new book to the library.
 * URL: /AddBookServlet
 * Access: Librarian only
 */
public class AddBookServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // -------------------------------------------------------
        // SESSION CHECK - Librarian only
        // -------------------------------------------------------
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("librarian") == null) {
            response.sendRedirect(request.getContextPath() + "/librarianLogin.jsp");
            return;
        }

        // -------------------------------------------------------
        // Read form parameters
        // -------------------------------------------------------
        String bookName   = request.getParameter("bookName");
        String authorName = request.getParameter("authorName");
        String status     = request.getParameter("availabilityStatus");

        // Server-side validation
        if (bookName == null || bookName.trim().isEmpty()
         || authorName == null || authorName.trim().isEmpty()) {
            request.getSession().setAttribute("error", "Book Name and Author Name are required.");
            response.sendRedirect(request.getContextPath() + "/librarian/addBook.jsp");
            return;
        }

        // -------------------------------------------------------
        // Create Book object and call DAO
        // -------------------------------------------------------
        Book book = new Book();
        book.setBookName(bookName.trim());
        book.setAuthorName(authorName.trim());
        book.setAvailabilityStatus((status != null && !status.trim().isEmpty()) ? status.trim() : "Available");

        BookDAO bookDAO = new BookDAO();
        boolean success = bookDAO.addBook(book);

        if (success) {
            request.getSession().setAttribute("success", "Book '" + bookName + "' added successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to add book. Please try again.");
        }

        response.sendRedirect(request.getContextPath() + "/librarian/addBook.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/librarian/addBook.jsp");
    }
}
