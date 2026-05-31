package dao;

import model.Librarian;
import util.DBConnection;

import java.sql.*;

/**
 * DAO CLASS: LibrarianDAO
 * Handles all JDBC operations for the librarian table.
 */
public class LibrarianDAO {

    // -------------------------------------------------------
    // LOGIN / AUTHENTICATION
    // -------------------------------------------------------

    /**
     * Validates librarian login credentials.
     * @return Librarian object if valid, null otherwise.
     */
    public Librarian validateLogin(String username, String password) {
        Librarian librarian = null;
        String sql = "SELECT * FROM librarian WHERE username = ? AND password = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                librarian = extractLibrarian(rs);
            }
        } catch (SQLException e) {
            System.err.println("LibrarianDAO.validateLogin error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return librarian;
    }

    // -------------------------------------------------------
    // GET LIBRARIAN BY ID
    // -------------------------------------------------------

    public Librarian getLibrarianById(int id) {
        Librarian librarian = null;
        String sql = "SELECT * FROM librarian WHERE librarian_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) librarian = extractLibrarian(rs);
        } catch (SQLException e) {
            System.err.println("LibrarianDAO.getLibrarianById error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return librarian;
    }

    // -------------------------------------------------------
    // TOTAL STUDENT COUNT (for dashboard)
    // -------------------------------------------------------

    public int getTotalStudents() {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM student");
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("LibrarianDAO.getTotalStudents error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return 0;
    }

    // -------------------------------------------------------
    // HELPER: Map ResultSet to Librarian
    // -------------------------------------------------------

    private Librarian extractLibrarian(ResultSet rs) throws SQLException {
        return new Librarian(
            rs.getInt("librarian_id"),
            rs.getString("librarian_name"),
            rs.getString("username"),
            rs.getString("password")
        );
    }
}
