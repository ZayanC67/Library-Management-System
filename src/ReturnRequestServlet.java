package servlet;

import dao.ReturnRequestDAO;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

public class ReturnRequestServlet extends HttpServlet {

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
        String redirect = request.getContextPath() + "/student/returnBook.jsp";

        if (bookIdStr == null || bookIdStr.trim().isEmpty()) {
            session.setAttribute("error", "Please select a borrowed book to return.");
            response.sendRedirect(redirect);
            return;
        }

        try {
            int bookId = Integer.parseInt(bookIdStr.trim());
            ReturnRequestDAO returnRequestDAO = new ReturnRequestDAO();
            String result = returnRequestDAO.submitReturnRequest(bookId, usn);

            switch (result) {
                case "success":
                    session.setAttribute("success", "Return request submitted to the librarian.");
                    break;
                case "no_active_issue":
                    session.setAttribute("error", "No active issue found for this book.");
                    break;
                case "already_pending":
                    session.setAttribute("error", "A return request for this book is already pending.");
                    break;
                default:
                    session.setAttribute("error", "Unable to submit return request at this time.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid book ID.");
        }
        response.sendRedirect(redirect);
    }
}
