package servlet;

import dao.PaymentDAO;
import model.Payment;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Date;

/**
 * SERVLET: PaymentServlet
 * Handles manual payment entries and payment record viewing.
 * URL: /PaymentServlet
 */
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Session check
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

        String role        = (String) session.getAttribute("role");
        String paymentType = request.getParameter("paymentType");
        String amountStr   = request.getParameter("amount");
        String usn         = request.getParameter("usn");

        // If student, force their own USN
        if ("student".equals(role)) {
            usn = (String) session.getAttribute("usn");
        }

        if (paymentType == null || paymentType.trim().isEmpty()
         || amountStr == null || amountStr.trim().isEmpty()
         || usn == null || usn.trim().isEmpty()) {
            session.setAttribute("error", "All payment fields are required.");
            redirectBack(response, request, role);
            return;
        }

        try {
            double amount = Double.parseDouble(amountStr.trim());
            if (amount <= 0) {
                session.setAttribute("error", "Payment amount must be greater than 0.");
                redirectBack(response, request, role);
                return;
            }

            Payment payment = new Payment();
            payment.setPaymentType(paymentType.trim());
            payment.setPaymentDate(new Date());
            payment.setAmount(amount);
            payment.setUsn(usn.trim());

            PaymentDAO paymentDAO = new PaymentDAO();
            boolean success = paymentDAO.addPayment(payment);

            if (success) {
                session.setAttribute("success", "Payment of Rs. " + String.format("%.2f", amount) + " recorded successfully!");
            } else {
                session.setAttribute("error", "Failed to record payment. Please try again.");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid amount. Please enter a valid number.");
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
            response.sendRedirect(request.getContextPath() + "/librarian/transactions.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/student/payment.jsp");
        }
    }
}
