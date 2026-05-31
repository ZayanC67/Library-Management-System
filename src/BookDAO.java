package dao;

import model.Book;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO CLASS: BookDAO
 * Handles all JDBC database operations related to the books table.
 */
public class BookDAO {

    // -------------------------------------------------------
    // ADD BOOK
    // -------------------------------------------------------

    public boolean addBook(Book book) {
        String sql = "INSERT INTO books (book_name, author_name, availability_status) VALUES (?, ?, ?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, book.getBookName());
            ps.setString(2, book.getAuthorName());
            ps.setString(3, book.getAvailabilityStatus() != null ? book.getAvailabilityStatus() : "Available");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("BookDAO.addBook error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // -------------------------------------------------------
    // REMOVE BOOK
    // -------------------------------------------------------

    public boolean removeBook(int bookId) {
        String sql = "DELETE FROM books WHERE book_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, bookId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("BookDAO.removeBook error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // -------------------------------------------------------
    // UPDATE BOOK
    // -------------------------------------------------------

    public boolean updateBook(Book book) {
        String sql = "UPDATE books SET book_name=?, author_name=?, availability_status=? WHERE book_id=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, book.getBookName());
            ps.setString(2, book.getAuthorName());
            ps.setString(3, book.getAvailabilityStatus());
            ps.setInt   (4, book.getBookId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("BookDAO.updateBook error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // -------------------------------------------------------
    // GET BOOK BY ID
    // -------------------------------------------------------

    public Book getBookById(int bookId) {
        Book book = null;
        String sql = "SELECT * FROM books WHERE book_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, bookId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) book = extractBook(rs);
        } catch (SQLException e) {
            System.err.println("BookDAO.getBookById error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return book;
    }

    // -------------------------------------------------------
    // GET ALL BOOKS
    // -------------------------------------------------------

    public List<Book> getAllBooks() {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT * FROM books ORDER BY book_id";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) list.add(extractBook(rs));
        } catch (SQLException e) {
            System.err.println("BookDAO.getAllBooks error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // -------------------------------------------------------
    // SEARCH BOOKS (by name, author, or id)
    // -------------------------------------------------------

    public List<Book> searchBooks(String keyword) {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE book_name LIKE ? OR author_name LIKE ? OR CAST(book_id AS CHAR) = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            String likeKw = "%" + keyword + "%";
            ps.setString(1, likeKw);
            ps.setString(2, likeKw);
            ps.setString(3, keyword);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(extractBook(rs));
        } catch (SQLException e) {
            System.err.println("BookDAO.searchBooks error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // -------------------------------------------------------
    // UPDATE AVAILABILITY STATUS
    // -------------------------------------------------------

    public boolean updateAvailability(int bookId, String status) {
        String sql = "UPDATE books SET availability_status = ? WHERE book_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt   (2, bookId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("BookDAO.updateAvailability error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // -------------------------------------------------------
    // COUNT HELPERS (for dashboard)
    // -------------------------------------------------------

    public int getTotalBooks() {
        return countByQuery("SELECT COUNT(*) FROM books");
    }

    public int getAvailableBooks() {
        return countByQuery("SELECT COUNT(*) FROM books WHERE availability_status = 'Available'");
    }

    public int getIssuedBooks() {
        return countByQuery("SELECT COUNT(*) FROM books WHERE availability_status = 'Issued'");
    }

    private int countByQuery(String sql) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("BookDAO.countByQuery error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return 0;
    }

    // -------------------------------------------------------
    // HELPER: Map ResultSet row to Book object
    // -------------------------------------------------------

    private Book extractBook(ResultSet rs) throws SQLException {
        return new Book(
            rs.getInt("book_id"),
            rs.getString("book_name"),
            rs.getString("author_name"),
            rs.getString("availability_status")
        );
    }
}
