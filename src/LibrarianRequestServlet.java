package servlet;

import dao.BookIssueDAO;
import dao.BookRequestDAO;
import dao.BookReturnDAO;
import dao.ReceiptDAO;
import dao.ReturnRequestDAO;
import model.BookRequest;
import model.ReturnRequest;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;

public class LibrarianRequestServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("librarian") == null) {
            response.sendRedirect(request.getContextPath() + "/librarianLogin.jsp");
            return;
        }

        String reqType = request.getParameter("requestType");
        String action  = request.getParameter("action");
        String idValue = request.getParameter("requestId");
        String comment = request.getParameter("comment") != null ? request.getParameter("comment") : "";

        if (reqType == null || action == null || idValue == null) {
            session.setAttribute("error", "Invalid librarian request action.");
            response.sendRedirect(request.getContextPath() + "/librarian/librarianDashboard.jsp");
            return;
        }

        try {
            int requestId = Integer.parseInt(idValue);
            if ("book".equals(reqType)) {
                handleBookRequest(requestId, action, comment, session);
            } else if ("return".equals(reqType)) {
                handleReturnRequest(requestId, action, comment, session);
            } else {
                session.setAttribute("error", "Unknown request type.");
            }
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid request identifier.");
        }

        response.sendRedirect(request.getContextPath() + "/librarian/librarianDashboard.jsp");
    }

    private void handleBookRequest(int requestId, String action, String comment, HttpSession session) {
        BookRequestDAO bookRequestDAO = new BookRequestDAO();
        BookRequest request = bookRequestDAO.getRequestById(requestId);
        if (request == null || !"Pending".equals(request.getStatus())) {
            session.setAttribute("error", "Request not found or already processed.");
            return;
        }

        if ("approve".equals(action)) {
            BookIssueDAO issueDAO = new BookIssueDAO();
            String result = issueDAO.issueBook(request.getBookId(), request.getUsn());
            if ("success".equals(result)) {
                LocalDate dueDate = LocalDate.now().plusDays(14);
                ReceiptDAO receiptDAO = new ReceiptDAO();
                receiptDAO.createIssueReceipt(requestId, "Approved", dueDate);
                bookRequestDAO.updateRequestStatus(requestId, "Approved", comment);
                session.setAttribute("success", "Book request approved and issue completed.");
            } else {
                bookRequestDAO.updateRequestStatus(requestId, "Rejected", "Could not issue book: " + result);
                session.setAttribute("error", "Unable to approve request: " + result);
            }
        } else if ("reject".equals(action)) {
            bookRequestDAO.updateRequestStatus(requestId, "Rejected", comment);
            session.setAttribute("success", "Book request rejected successfully.");
        } else {
            session.setAttribute("error", "Invalid approval action.");
        }
    }

    private void handleReturnRequest(int requestId, String action, String comment, HttpSession session) {
        ReturnRequestDAO returnRequestDAO = new ReturnRequestDAO();
        ReturnRequest request = returnRequestDAO.getRequestById(requestId);
        if (request == null || !"Pending".equals(request.getStatus())) {
            session.setAttribute("error", "Return request not found or already processed.");
            return;
        }

        if ("approve".equals(action)) {
            BookReturnDAO returnDAO = new BookReturnDAO();
            double fine = returnDAO.returnBook(request.getBookId(), request.getUsn());
            if (fine >= 0) {
                ReceiptDAO receiptDAO = new ReceiptDAO();
                receiptDAO.createReturnReceipt(requestId, fine, "Approved");
                returnRequestDAO.updateRequestStatus(requestId, "Approved", comment);
                String message = "Return request approved.";
                if (fine > 0) {
                    message += " Fine charged: ₹" + String.format("%.2f", fine) + ".";
                }
                session.setAttribute("success", message);
            } else {
                returnRequestDAO.updateRequestStatus(requestId, "Rejected", "No active issue could be returned.");
                session.setAttribute("error", "Unable to approve return request. No active issue found.");
            }
        } else if ("reject".equals(action)) {
            returnRequestDAO.updateRequestStatus(requestId, "Rejected", comment);
            session.setAttribute("success", "Return request rejected successfully.");
        } else {
            session.setAttribute("error", "Invalid approval action.");
        }
    }
}
