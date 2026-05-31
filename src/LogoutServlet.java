package servlet;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * SERVLET: LogoutServlet
 * Clears the current session and redirects to the login page.
 * URL: /LogoutServlet
 */
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Invalidate the session
        HttpSession session = request.getSession(false);
        String role = "";
        if (session != null) {
            role = (String) session.getAttribute("role");
            session.invalidate();
        }

        // Redirect to appropriate login page with logout message
        if ("librarian".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/librarianLogin.jsp?logout=true");
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp?logout=true");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
