package dao;

import java.sql.*;
import java.time.LocalDate;
import java.util.UUID;
import model.IssueReceipt;
import model.ReturnReceipt;
import util.DBConnection;

public class ReceiptDAO {

    public boolean createIssueReceipt(int requestId, String approvalStatus, LocalDate dueDate) {
        String sql = "INSERT INTO issue_receipt (request_id, receipt_number, generated_date, due_date, approval_status) " +
                     "VALUES (?, ?, CURDATE(), ?, ?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, requestId);
            ps.setString(2, generateReceiptNumber("ISS"));
            ps.setDate(3, Date.valueOf(dueDate));
            ps.setString(4, approvalStatus);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ReceiptDAO.createIssueReceipt error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public boolean createReturnReceipt(int requestId, double fineAmount, String returnStatus) {
        String sql = "INSERT INTO return_receipt (request_id, receipt_number, generated_date, fine_amount, return_status) " +
                     "VALUES (?, ?, CURDATE(), ?, ?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, requestId);
            ps.setString(2, generateReceiptNumber("RTN"));
            ps.setDouble(3, fineAmount);
            ps.setString(4, returnStatus);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ReceiptDAO.createReturnReceipt error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public IssueReceipt getIssueReceiptByRequestId(int requestId) {
        IssueReceipt receipt = null;
        String sql = "SELECT * FROM issue_receipt WHERE request_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, requestId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                receipt = new IssueReceipt(
                        rs.getInt("receipt_id"),
                        rs.getInt("request_id"),
                        rs.getString("receipt_number"),
                        rs.getDate("generated_date"),
                        rs.getDate("due_date"),
                        rs.getString("approval_status")
                );
            }
        } catch (SQLException e) {
            System.err.println("ReceiptDAO.getIssueReceiptByRequestId error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return receipt;
    }

    public ReturnReceipt getReturnReceiptByRequestId(int requestId) {
        ReturnReceipt receipt = null;
        String sql = "SELECT * FROM return_receipt WHERE request_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, requestId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                receipt = new ReturnReceipt(
                        rs.getInt("receipt_id"),
                        rs.getInt("request_id"),
                        rs.getString("receipt_number"),
                        rs.getDate("generated_date"),
                        rs.getDouble("fine_amount"),
                        rs.getString("return_status")
                );
            }
        } catch (SQLException e) {
            System.err.println("ReceiptDAO.getReturnReceiptByRequestId error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return receipt;
    }

    private String generateReceiptNumber(String prefix) {
        return prefix + "-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
    }
}
