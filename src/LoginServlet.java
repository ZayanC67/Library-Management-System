package servlet;

import dao.LibrarianDAO;
import dao.StudentDAO;
import model.Librarian;
import model.Student;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * SERVLET: LoginServlet
 * Handles both Student and Librarian login authentication.
 * URL: /LoginServlet
 */
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = request.getParameter("role");
        String password = request.getParameter("password");

        if ("student".equals(role)) {
            String usn = request.getParameter("username");

            if (usn == null || usn.trim().isEmpty() || password == null || password.trim().isEmpty()) {
                request.setAttribute("error", "USN and Password are required.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                return;
            }

            StudentDAO studentDAO = new StudentDAO();
            Student student = studentDAO.validateLogin(usn.trim(), password.trim());

            if (student != null) {
                HttpSession session = request.getSession(true);
                session.setAttribute("student", student);
                session.setAttribute("role", "student");
                session.setAttribute("usn", student.getUsn());
                session.setMaxInactiveInterval(30 * 60);
                response.sendRedirect(request.getContextPath() + "/student/studentDashboard.jsp");
            } else {
                request.setAttribute("error", "Invalid USN or Password. Please try again.");
                request.setAttribute("role", "student");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }

        } else if ("librarian".equals(role)) {
            String username = request.getParameter("username");

            if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
                request.setAttribute("error", "Username and Password are required.");
                request.getRequestDispatcher("/librarianLogin.jsp").forward(request, response);
                return;
            }

            LibrarianDAO librarianDAO = new LibrarianDAO();
            Librarian librarian = librarianDAO.validateLogin(username.trim(), password.trim());

            if (librarian != null) {
                HttpSession session = request.getSession(true);
                session.setAttribute("librarian", librarian);
                session.setAttribute("role", "librarian");
                session.setAttribute("librarianName", librarian.getLibrarianName());
                session.setMaxInactiveInterval(30 * 60);
                response.sendRedirect(request.getContextPath() + "/librarian/librarianDashboard.jsp");
            } else {
                request.setAttribute("error", "Invalid Username or Password. Please try again.");
                request.setAttribute("role", "librarian");
                request.getRequestDispatcher("/librarianLogin.jsp").forward(request, response);
            }

        } else {
            request.setAttribute("error", "Invalid login role selected.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}
