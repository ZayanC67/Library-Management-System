package servlet;

import dao.BookDAO;
import model.Book;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * SERVLET: SearchBookServlet
 * Handles book search requests from both student and librarian.
 * URL: /SearchBookServlet
 */
public class SearchBookServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleSearch(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleSearch(request, response);
    }

    private void handleSearch(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session check - MUST have valid session
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/librarianLogin.jsp");
            return;
        }

        // Get keyword parameter
        String keyword = request.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }

        // Perform search
        List<Book> bookList = null;
        if (!keyword.trim().isEmpty()) {
            BookDAO bookDAO = new BookDAO();
            bookList = bookDAO.searchBooks(keyword.trim());
        }

        // Set attributes for JSP
        request.setAttribute("bookList", bookList);
        request.setAttribute("keyword", keyword);

        // STRICT ROLE-BASED ROUTING
        Object librarianObj = session.getAttribute("librarian");
        Object studentObj = session.getAttribute("student");

        if (librarianObj != null) {
            // Librarian is logged in - ONLY show Manage Books (Admin Portal)
            request.getRequestDispatcher("/librarian/manageBooks.jsp").forward(request, response);
            return;
        } 
        else if (studentObj != null) {
            // Student is logged in - ONLY show Student Search (Student Portal)
            request.getRequestDispatcher("/student/searchBook.jsp").forward(request, response);
            return;
        }
        // No valid role - send to login
        else {
            response.sendRedirect(request.getContextPath() + "/librarianLogin.jsp");
            return;
        }
    }
}
