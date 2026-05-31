package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.ReturnRequest;
import util.DBConnection;

public class ReturnRequestDAO {

    public String submitReturnRequest(int bookId, String usn) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement checkIssue = conn.prepareStatement(
                    "SELECT issue_id FROM book_issue WHERE book_id = ? AND usn = ? ORDER BY issue_date DESC LIMIT 1");
            checkIssue.setInt(1, bookId);
            checkIssue.setString(2, usn);
            ResultSet rsIssue = checkIssue.executeQuery();
            if (!rsIssue.next()) {
                return "no_active_issue";
            }

            PreparedStatement checkPending = conn.prepareStatement(
                    "SELECT request_id FROM return_request WHERE book_id = ? AND usn = ? AND status = 'Pending'");
            checkPending.setInt(1, bookId);
            checkPending.setString(2, usn);
            ResultSet rsPending = checkPending.executeQuery();
            if (rsPending.next()) {
                return "already_pending";
            }

            PreparedStatement insert = conn.prepareStatement(
                    "INSERT INTO return_request (book_id, usn, request_date, status) VALUES (?, ?, CURDATE(), 'Pending')");
            insert.setInt(1, bookId);
            insert.setString(2, usn);
            insert.executeUpdate();
            return "success";
        } catch (SQLException e) {
            System.err.println("ReturnRequestDAO.submitReturnRequest error: " + e.getMessage());
            return "error";
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public List<ReturnRequest> getPendingReturnRequests() {
        return getRequestsByStatus("Pending");
    }

    public List<ReturnRequest> getRequestsByUsn(String usn) {
        List<ReturnRequest> list = new ArrayList<>();
        String sql = "SELECT rr.request_id, rr.book_id, rr.request_date, rr.usn, rr.status, rr.librarian_comment, " +
                     "b.book_name, s.student_name " +
                     "FROM return_request rr " +
                     "JOIN books b ON rr.book_id = b.book_id " +
                     "JOIN student s ON rr.usn = s.usn " +
                     "WHERE rr.usn = ? ORDER BY rr.request_date DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, usn);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(extractReturnRequest(rs));
        } catch (SQLException e) {
            System.err.println("ReturnRequestDAO.getRequestsByUsn error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    public ReturnRequest getRequestById(int requestId) {
        ReturnRequest request = null;
        String sql = "SELECT rr.request_id, rr.book_id, rr.request_date, rr.usn, rr.status, rr.librarian_comment, " +
                     "b.book_name, s.student_name " +
                     "FROM return_request rr " +
                     "JOIN books b ON rr.book_id = b.book_id " +
                     "JOIN student s ON rr.usn = s.usn " +
                     "WHERE rr.request_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, requestId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) request = extractReturnRequest(rs);
        } catch (SQLException e) {
            System.err.println("ReturnRequestDAO.getRequestById error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return request;
    }

    public boolean updateRequestStatus(int requestId, String status, String comment) {
        String sql = "UPDATE return_request SET status = ?, librarian_comment = ? WHERE request_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, comment);
            ps.setInt(3, requestId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("ReturnRequestDAO.updateRequestStatus error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    private List<ReturnRequest> getRequestsByStatus(String status) {
        List<ReturnRequest> list = new ArrayList<>();
        String sql = "SELECT rr.request_id, rr.book_id, rr.request_date, rr.usn, rr.status, rr.librarian_comment, " +
                     "b.book_name, s.student_name " +
                     "FROM return_request rr " +
                     "JOIN books b ON rr.book_id = b.book_id " +
                     "JOIN student s ON rr.usn = s.usn " +
                     "WHERE rr.status = ? ORDER BY rr.request_date DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(extractReturnRequest(rs));
        } catch (SQLException e) {
            System.err.println("ReturnRequestDAO.getRequestsByStatus error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    private ReturnRequest extractReturnRequest(ResultSet rs) throws SQLException {
        ReturnRequest request = new ReturnRequest(
                rs.getInt("request_id"),
                rs.getInt("book_id"),
                rs.getDate("request_date"),
                rs.getString("usn"),
                rs.getString("status"),
                rs.getString("librarian_comment")
        );
        request.setBookName(rs.getString("book_name"));
        request.setStudentName(rs.getString("student_name"));
        return request;
    }
}
