package dao;

import model.BookReturn;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO CLASS: BookReturnDAO
 * Handles all JDBC operations for returning books.
 * Also updates book availability and calculates fines.
 */
public class BookReturnDAO {

    private static final int FREE_DAYS = 14;       // Days before fine starts
    private static final double FINE_PER_DAY = 2.0; // Rs. per day

    // -------------------------------------------------------
    // RETURN A BOOK
    // -------------------------------------------------------

    /**
     * Records a book return and updates availability.
     * Business Logic:
     *   1. Verify there is an active issue for this book+student
     *   2. Prevent duplicate return for the same issue
     *   3. Insert into book_return
     *   4. Update books.availability_status = 'Available'
     *   5. If fine applies, insert into payment
     *
     * @return fine amount (0 if no fine), or -1 on error / no active issue
     */
    public double returnBook(int bookId, String usn) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            PreparedStatement findIssue = conn.prepareStatement(
                "SELECT issue_id, issue_date FROM book_issue " +
                "WHERE book_id = ? AND usn = ? " +
                "ORDER BY issue_date DESC LIMIT 1");
            findIssue.setInt(1, bookId);
            findIssue.setString(2, usn);
            ResultSet rsIssue = findIssue.executeQuery();

            if (!rsIssue.next()) {
                conn.rollback();
                return -1;
            }

            Date issueDate = rsIssue.getDate("issue_date");

            PreparedStatement checkReturn = conn.prepareStatement(
                "SELECT 1 FROM book_return " +
                "WHERE book_id = ? AND usn = ? AND return_date >= ? LIMIT 1");
            checkReturn.setInt(1, bookId);
            checkReturn.setString(2, usn);
            checkReturn.setDate(3, issueDate);
            ResultSet rsReturn = checkReturn.executeQuery();

            if (rsReturn.next()) {
                conn.rollback();
                return -1;
            }

            long diffMs = System.currentTimeMillis() - issueDate.getTime();
            long diffDays = diffMs / (1000L * 60 * 60 * 24);
            double fine = diffDays > FREE_DAYS ? (diffDays - FREE_DAYS) * FINE_PER_DAY : 0.0;

            PreparedStatement insertReturn = conn.prepareStatement(
                "INSERT INTO book_return (book_id, return_date, usn) VALUES (?, CURDATE(), ?)");
            insertReturn.setInt(1, bookId);
            insertReturn.setString(2, usn);
            insertReturn.executeUpdate();

            PreparedStatement updateBook = conn.prepareStatement(
                "UPDATE books SET availability_status = 'Available' WHERE book_id = ?");
            updateBook.setInt(1, bookId);
            updateBook.executeUpdate();

            if (fine > 0) {
                PreparedStatement insertPayment = conn.prepareStatement(
                    "INSERT INTO payment (payment_type, payment_date, amount, usn) VALUES ('Fine', CURDATE(), ?, ?)");
                insertPayment.setDouble(1, fine);
                insertPayment.setString(2, usn);
                insertPayment.executeUpdate();
            }

            conn.commit();
            return fine;

        } catch (SQLException e) {
            try {
                if (conn != null) conn.rollback();
            } catch (SQLException ex) {
                // ignore rollback failure
            }
            System.err.println("BookReturnDAO.returnBook error: " + e.getMessage());
            return -1;
        } finally {
            try {
                if (conn != null) conn.setAutoCommit(true);
            } catch (SQLException e) {
                // ignore auto-commit reset failure
            }
            DBConnection.closeConnection(conn);
        }
    }

    // -------------------------------------------------------
    // GET RETURN HISTORY BY STUDENT USN
    // -------------------------------------------------------

    public List<BookReturn> getReturnsByUsn(String usn) {
        List<BookReturn> list = new ArrayList<>();
        String sql = "SELECT br.return_id, br.book_id, br.return_date, br.usn, b.book_name, s.student_name " +
                     "FROM book_return br " +
                     "JOIN books b ON br.book_id = b.book_id " +
                     "JOIN student s ON br.usn = s.usn " +
                     "WHERE br.usn = ? ORDER BY br.return_date DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, usn);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(extractBookReturn(rs));
        } catch (SQLException e) {
            System.err.println("BookReturnDAO.getReturnsByUsn error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // -------------------------------------------------------
    // GET ALL RETURNS (for librarian dashboard)
    // -------------------------------------------------------

    public List<BookReturn> getAllReturns() {
        List<BookReturn> list = new ArrayList<>();
        String sql = "SELECT br.return_id, br.book_id, br.return_date, br.usn, b.book_name, s.student_name " +
                     "FROM book_return br " +
                     "JOIN books b ON br.book_id = b.book_id " +
                     "JOIN student s ON br.usn = s.usn " +
                     "ORDER BY br.return_date DESC";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) list.add(extractBookReturn(rs));
        } catch (SQLException e) {
            System.err.println("BookReturnDAO.getAllReturns error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // -------------------------------------------------------
    // HELPER: Map ResultSet to BookReturn
    // -------------------------------------------------------

    private BookReturn extractBookReturn(ResultSet rs) throws SQLException {
        BookReturn br = new BookReturn(
            rs.getInt("return_id"),
            rs.getInt("book_id"),
            rs.getDate("return_date"),
            rs.getString("usn")
        );
        try { br.setBookName(rs.getString("book_name")); } catch (SQLException e) { /* ignore */ }
        try { br.setStudentName(rs.getString("student_name")); } catch (SQLException e) { /* ignore */ }
        return br;
    }
}
