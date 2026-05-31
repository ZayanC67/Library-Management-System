package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.BookIssue;
import util.DBConnection;

/**
 * DAO CLASS: BookIssueDAO
 * Handles all JDBC operations for issuing books.
 * Also updates book availability after issue.
 */
public class BookIssueDAO {

    // -------------------------------------------------------
    // ISSUE A BOOK
    // -------------------------------------------------------

    /**
     * Issues a book to a student.
     * Business Logic:
     *   1. Check if book is Available
     *   2. Check no active issue already exists for this student+book
     *   3. Insert into book_issue
     *   4. Update books.availability_status = 'Issued'
     *
     * @return "success", "already_issued", "not_available", or "error"
     */
    public String issueBook(int bookId, String usn) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Transaction start

            // 1. Check availability
            PreparedStatement checkBook = conn.prepareStatement(
                "SELECT availability_status FROM books WHERE book_id = ?");
            checkBook.setInt(1, bookId);
            ResultSet rsBook = checkBook.executeQuery();
            if (!rsBook.next() || !rsBook.getString("availability_status").equals("Available")) {
                conn.rollback();
                return "not_available";
            }

            // 2. Check duplicate active issue
            PreparedStatement checkIssue = conn.prepareStatement(
                "SELECT issue_id FROM book_issue bi " +
                "WHERE bi.book_id = ? AND bi.usn = ? " +
                "AND NOT EXISTS (SELECT 1 FROM book_return br WHERE br.book_id = bi.book_id AND br.usn = bi.usn AND br.return_date >= bi.issue_date)");
            checkIssue.setInt(1, bookId);
            checkIssue.setString(2, usn);
            ResultSet rsIssue = checkIssue.executeQuery();
            if (rsIssue.next()) {
                conn.rollback();
                return "already_issued";
            }

            // 3. Insert into book_issue
            PreparedStatement insertIssue = conn.prepareStatement(
                "INSERT INTO book_issue (book_id, issue_date, usn) VALUES (?, CURDATE(), ?)");
            insertIssue.setInt(1, bookId);
            insertIssue.setString(2, usn);
            insertIssue.executeUpdate();

            // 4. Update availability
            PreparedStatement updateBook = conn.prepareStatement(
                "UPDATE books SET availability_status = 'Issued' WHERE book_id = ?");
            updateBook.setInt(1, bookId);
            updateBook.executeUpdate();

            conn.commit(); // Transaction commit
            return "success";

        } catch (SQLException e) {
            try { if (conn != null) conn.rollback(); } catch (SQLException ex) { /* ignore */ }
            System.err.println("BookIssueDAO.issueBook error: " + e.getMessage());
            return "error";
        } finally {
            try { if (conn != null) conn.setAutoCommit(true); } catch (SQLException e) { /* ignore */ }
            DBConnection.closeConnection(conn);
        }
    }

    // -------------------------------------------------------
    // GET ISSUED BOOKS BY STUDENT USN
    // -------------------------------------------------------

    public List<BookIssue> getIssuesByUsn(String usn) {
        List<BookIssue> list = new ArrayList<>();
        String sql = "SELECT bi.issue_id, bi.book_id, bi.issue_date, bi.usn, b.book_name, s.student_name " +
                     "FROM book_issue bi " +
                     "JOIN books b ON bi.book_id = b.book_id " +
                     "JOIN student s ON bi.usn = s.usn " +
                     "WHERE bi.usn = ? " +
                     "AND NOT EXISTS (SELECT 1 FROM book_return br WHERE br.book_id = bi.book_id AND br.usn = bi.usn AND br.return_date >= bi.issue_date) " +
                     "ORDER BY bi.issue_date DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, usn);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(extractBookIssue(rs));
        } catch (SQLException e) {
            System.err.println("BookIssueDAO.getIssuesByUsn error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // -------------------------------------------------------
    // GET ALL ISSUE TRANSACTIONS (for librarian)
    // -------------------------------------------------------

    public List<BookIssue> getAllIssues() {
        List<BookIssue> list = new ArrayList<>();
        String sql = "SELECT bi.issue_id, bi.book_id, bi.issue_date, bi.usn, b.book_name, s.student_name " +
                     "FROM book_issue bi " +
                     "JOIN books b ON bi.book_id = b.book_id " +
                     "JOIN student s ON bi.usn = s.usn " +
                     "ORDER BY bi.issue_date DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) list.add(extractBookIssue(rs));
        } catch (SQLException e) {
            System.err.println("BookIssueDAO.getAllIssues error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // -------------------------------------------------------
    // COUNT ACTIVE ISSUES (for dashboard)
    // -------------------------------------------------------

    public int getTotalIssues() {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM book_issue");
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("BookIssueDAO.getTotalIssues error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return 0;
    }

    // -------------------------------------------------------
    // HELPER: Map ResultSet to BookIssue
    // -------------------------------------------------------

    private BookIssue extractBookIssue(ResultSet rs) throws SQLException {
        BookIssue bi = new BookIssue(
            rs.getInt("issue_id"),
            rs.getInt("book_id"),
            rs.getDate("issue_date"),
            rs.getString("usn")
        );
        try { bi.setBookName(rs.getString("book_name")); } catch (SQLException e) { /* column may not exist */ }
        try { bi.setStudentName(rs.getString("student_name")); } catch (SQLException e) { /* column may not exist */ }
        return bi;
    }
}
