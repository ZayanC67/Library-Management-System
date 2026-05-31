package dao;

import model.Payment;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO CLASS: PaymentDAO
 * Handles all JDBC operations related to the payment table.
 */
public class PaymentDAO {

    // -------------------------------------------------------
    // ADD PAYMENT RECORD
    // -------------------------------------------------------

    public boolean addPayment(Payment payment) {
        String sql = "INSERT INTO payment (payment_type, payment_date, amount, usn) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, payment.getPaymentType());
            ps.setDate  (2, new java.sql.Date(payment.getPaymentDate().getTime()));
            ps.setDouble(3, payment.getAmount());
            ps.setString(4, payment.getUsn());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("PaymentDAO.addPayment error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // -------------------------------------------------------
    // GET PAYMENTS BY STUDENT USN
    // -------------------------------------------------------

    public List<Payment> getPaymentsByUsn(String usn) {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.*, s.student_name FROM payment p " +
                     "JOIN student s ON p.usn = s.usn " +
                     "WHERE p.usn = ? ORDER BY p.payment_date DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, usn);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(extractPayment(rs));
        } catch (SQLException e) {
            System.err.println("PaymentDAO.getPaymentsByUsn error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // -------------------------------------------------------
    // GET ALL PAYMENTS (for librarian)
    // -------------------------------------------------------

    public List<Payment> getAllPayments() {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT p.*, s.student_name FROM payment p " +
                     "JOIN student s ON p.usn = s.usn " +
                     "ORDER BY p.payment_date DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) list.add(extractPayment(rs));
        } catch (SQLException e) {
            System.err.println("PaymentDAO.getAllPayments error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // -------------------------------------------------------
    // TOTAL FINE COLLECTED (for librarian dashboard)
    // -------------------------------------------------------

    public double getTotalFineCollected() {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT COALESCE(SUM(amount), 0) FROM payment WHERE payment_type = 'Fine'");
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            System.err.println("PaymentDAO.getTotalFineCollected error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return 0.0;
    }

    // -------------------------------------------------------
    // HELPER: Map ResultSet to Payment
    // -------------------------------------------------------

    private Payment extractPayment(ResultSet rs) throws SQLException {
        Payment p = new Payment(
            rs.getInt("payment_id"),
            rs.getString("payment_type"),
            rs.getDate("payment_date"),
            rs.getDouble("amount"),
            rs.getString("usn")
        );
        try { p.setStudentName(rs.getString("student_name")); } catch (SQLException e) { /* ignore */ }
        return p;
    }
}
