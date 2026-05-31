package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.BookRequest;
import util.DBConnection;

public class BookRequestDAO {

    public String submitRequest(int bookId, String usn) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();

            PreparedStatement checkBook = conn.prepareStatement(
                    "SELECT availability_status FROM books WHERE book_id = ?");
            checkBook.setInt(1, bookId);
            ResultSet rsBook = checkBook.executeQuery();
            if (!rsBook.next()) {
                return "book_not_found";
            }
            if (!"Available".equals(rsBook.getString("availability_status"))) {
                return "not_available";
            }

            PreparedStatement checkPending = conn.prepareStatement(
                    "SELECT request_id FROM book_request WHERE book_id = ? AND usn = ? AND status = 'Pending'");
            checkPending.setInt(1, bookId);
            checkPending.setString(2, usn);
            ResultSet rsPending = checkPending.executeQuery();
            if (rsPending.next()) {
                return "already_pending";
            }

            PreparedStatement insert = conn.prepareStatement(
                    "INSERT INTO book_request (book_id, usn, request_date, status) VALUES (?, ?, CURDATE(), 'Pending')");
            insert.setInt(1, bookId);
            insert.setString(2, usn);
            insert.executeUpdate();
            return "success";
        } catch (SQLException e) {
            System.err.println("BookRequestDAO.submitRequest error: " + e.getMessage());
            return "error";
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    public List<BookRequest> getPendingRequests() {
        return getRequestsByStatus("Pending");
    }

    public List<BookRequest> getRequestsByUsn(String usn) {
        List<BookRequest> list = new ArrayList<>();
        String sql = "SELECT br.request_id, br.book_id, br.request_date, br.usn, br.status, br.librarian_comment, " +
                     "b.book_name, b.author_name, s.student_name " +
                     "FROM book_request br " +
                     "JOIN books b ON br.book_id = b.book_id " +
                     "JOIN student s ON br.usn = s.usn " +
                     "WHERE br.usn = ? ORDER BY br.request_date DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, usn);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(extractBookRequest(rs));
        } catch (SQLException e) {
            System.err.println("BookRequestDAO.getRequestsByUsn error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    public BookRequest getRequestById(int requestId) {
        BookRequest request = null;
        String sql = "SELECT br.request_id, br.book_id, br.request_date, br.usn, br.status, br.librarian_comment, " +
                     "b.book_name, b.author_name, s.student_name " +
                     "FROM book_request br " +
                     "JOIN books b ON br.book_id = b.book_id " +
                     "JOIN student s ON br.usn = s.usn " +
                     "WHERE br.request_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, requestId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) request = extractBookRequest(rs);
        } catch (SQLException e) {
            System.err.println("BookRequestDAO.getRequestById error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return request;
    }

    public boolean updateRequestStatus(int requestId, String status, String comment) {
        String sql = "UPDATE book_request SET status = ?, librarian_comment = ? WHERE request_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, comment);
            ps.setInt(3, requestId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("BookRequestDAO.updateRequestStatus error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    private List<BookRequest> getRequestsByStatus(String status) {
        List<BookRequest> list = new ArrayList<>();
        String sql = "SELECT br.request_id, br.book_id, br.request_date, br.usn, br.status, br.librarian_comment, " +
                     "b.book_name, b.author_name, s.student_name " +
                     "FROM book_request br " +
                     "JOIN books b ON br.book_id = b.book_id " +
                     "JOIN student s ON br.usn = s.usn " +
                     "WHERE br.status = ? ORDER BY br.request_date DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(extractBookRequest(rs));
        } catch (SQLException e) {
            System.err.println("BookRequestDAO.getRequestsByStatus error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    private BookRequest extractBookRequest(ResultSet rs) throws SQLException {
        BookRequest request = new BookRequest(
                rs.getInt("request_id"),
                rs.getInt("book_id"),
                rs.getDate("request_date"),
                rs.getString("usn"),
                rs.getString("status"),
                rs.getString("librarian_comment")
        );
        request.setBookName(rs.getString("book_name"));
        request.setAuthorName(rs.getString("author_name"));
        request.setStudentName(rs.getString("student_name"));
        return request;
    }
}
