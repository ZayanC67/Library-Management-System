package dao;

import model.Student;
import util.DBConnection;

import java.sql.*;

/**
 * DAO CLASS: StudentDAO
 * Handles all JDBC database operations related to the Student table.
 */
public class StudentDAO {

    // -------------------------------------------------------
    // LOGIN / AUTHENTICATION
    // -------------------------------------------------------

    /**
     * Validates student login credentials.
     * @return Student object if valid, null otherwise.
     */
    public Student validateLogin(String usn, String password) {
        Student student = null;
        String sql = "SELECT * FROM student WHERE usn = ? AND password = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, usn);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                student = extractStudent(rs);
            }
        } catch (SQLException e) {
            System.err.println("StudentDAO.validateLogin error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return student;
    }

    // -------------------------------------------------------
    // REGISTER NEW STUDENT
    // -------------------------------------------------------

    /**
     * Inserts a new student record into the database.
     * @return true if successful.
     */
    public boolean registerStudent(Student student) {
        // Check duplicate USN
        if (getStudentByUsn(student.getUsn()) != null) return false;

        String sql = "INSERT INTO student (usn, student_name, semester, branch, phone_no, password) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, student.getUsn());
            ps.setString(2, student.getStudentName());
            ps.setInt   (3, student.getSemester());
            ps.setString(4, student.getBranch());
            ps.setString(5, student.getPhoneNo());
            ps.setString(6, student.getPassword());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("StudentDAO.registerStudent error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // -------------------------------------------------------
    // GET STUDENT BY USN
    // -------------------------------------------------------

    public Student getStudentByUsn(String usn) {
        Student student = null;
        String sql = "SELECT * FROM student WHERE usn = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, usn);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                student = extractStudent(rs);
            }
        } catch (SQLException e) {
            System.err.println("StudentDAO.getStudentByUsn error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return student;
    }

    // -------------------------------------------------------
    // GET ALL STUDENTS
    // -------------------------------------------------------

    public java.util.List<Student> getAllStudents() {
        java.util.List<Student> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM student ORDER BY usn";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            while (rs.next()) {
                list.add(extractStudent(rs));
            }
        } catch (SQLException e) {
            System.err.println("StudentDAO.getAllStudents error: " + e.getMessage());
        } finally {
            DBConnection.closeConnection(conn);
        }
        return list;
    }

    // -------------------------------------------------------
    // UPDATE STUDENT PROFILE
    // -------------------------------------------------------

    public boolean updateStudent(Student student) {
        String sql = "UPDATE student SET student_name=?, semester=?, branch=?, phone_no=? WHERE usn=?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, student.getStudentName());
            ps.setInt   (2, student.getSemester());
            ps.setString(3, student.getBranch());
            ps.setString(4, student.getPhoneNo());
            ps.setString(5, student.getUsn());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("StudentDAO.updateStudent error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // -------------------------------------------------------
    // DELETE STUDENT
    // -------------------------------------------------------

    public boolean deleteStudent(String usn) {
        String sql = "DELETE FROM student WHERE usn = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, usn);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("StudentDAO.deleteStudent error: " + e.getMessage());
            return false;
        } finally {
            DBConnection.closeConnection(conn);
        }
    }

    // -------------------------------------------------------
    // HELPER: Map ResultSet row to Student object
    // -------------------------------------------------------

    private Student extractStudent(ResultSet rs) throws SQLException {
        return new Student(
            rs.getString("usn"),
            rs.getString("student_name"),
            rs.getInt("semester"),
            rs.getString("branch"),
            rs.getString("phone_no"),
            rs.getString("password")
        );
    }
}
