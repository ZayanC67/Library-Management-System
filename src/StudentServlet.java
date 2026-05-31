package servlet;

import dao.StudentDAO;
import model.Student;

import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * SERVLET: StudentServlet
 * Handles student profile and dashboard actions.
 * URL: /StudentServlet
 */
public class StudentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("register".equals(action)) {
            handleRegister(request, response);
        } else if ("update".equals(action)) {
            handleUpdate(request, response);
        } else if ("delete".equals(action)) {
            handleDelete(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }
    }

    // -------------------------------------------------------
    // REGISTER NEW STUDENT
    // -------------------------------------------------------
    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String usn          = request.getParameter("usn");
        String studentName  = request.getParameter("studentName");
        String semesterStr  = request.getParameter("semester");
        String branch       = request.getParameter("branch");
        String phoneNo      = request.getParameter("phoneNo");
        String password     = request.getParameter("password");

        // Server-side validation
        if (usn == null || usn.trim().isEmpty()
         || studentName == null || studentName.trim().isEmpty()
         || semesterStr == null || semesterStr.trim().isEmpty()
         || branch == null || branch.trim().isEmpty()
         || phoneNo == null || phoneNo.trim().isEmpty()
         || password == null || password.trim().isEmpty()) {
            request.getSession().setAttribute("error", "All fields are required for registration.");
            response.sendRedirect(request.getContextPath() + "/login.jsp?tab=register");
            return;
        }

        if (!phoneNo.trim().matches("\\d{10}")) {
            request.getSession().setAttribute("error", "Phone number must be exactly 10 digits.");
            response.sendRedirect(request.getContextPath() + "/login.jsp?tab=register");
            return;
        }

        try {
            int semester = Integer.parseInt(semesterStr.trim());
            Student student = new Student(usn.trim(), studentName.trim(), semester,
                                          branch.trim(), phoneNo.trim(), password.trim());
            StudentDAO dao = new StudentDAO();
            boolean success = dao.registerStudent(student);

            if (success) {
                request.getSession().setAttribute("success", "Registration successful! Please login.");
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            } else {
                request.getSession().setAttribute("error", "USN already exists. Please use a different USN.");
                response.sendRedirect(request.getContextPath() + "/login.jsp?tab=register");
            }

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Invalid semester value.");
            response.sendRedirect(request.getContextPath() + "/login.jsp?tab=register");
        }
    }

    // -------------------------------------------------------
    // UPDATE STUDENT PROFILE
    // -------------------------------------------------------
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("student") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String usn         = (String) session.getAttribute("usn");
        String studentName = request.getParameter("studentName");
        String semesterStr = request.getParameter("semester");
        String branch      = request.getParameter("branch");
        String phoneNo     = request.getParameter("phoneNo");

        if (studentName == null || studentName.trim().isEmpty()
         || semesterStr == null || semesterStr.trim().isEmpty()
         || branch == null || branch.trim().isEmpty()
         || phoneNo == null || phoneNo.trim().isEmpty()) {
            session.setAttribute("error", "All profile fields are required.");
            response.sendRedirect(request.getContextPath() + "/student/profile.jsp");
            return;
        }

        if (!phoneNo.trim().matches("\\d{10}")) {
            session.setAttribute("error", "Phone number must be exactly 10 digits.");
            response.sendRedirect(request.getContextPath() + "/student/profile.jsp");
            return;
        }

        try {
            int semester = Integer.parseInt(semesterStr.trim());
            Student student = new Student();
            student.setUsn(usn);
            student.setStudentName(studentName.trim());
            student.setSemester(semester);
            student.setBranch(branch.trim());
            student.setPhoneNo(phoneNo.trim());

            StudentDAO dao = new StudentDAO();
            boolean success = dao.updateStudent(student);

            if (success) {
                // Update session data
                Student updatedStudent = dao.getStudentByUsn(usn);
                session.setAttribute("student", updatedStudent);
                session.setAttribute("success", "Profile updated successfully!");
            } else {
                session.setAttribute("error", "Failed to update profile. Please try again.");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid semester value.");
        }

        response.sendRedirect(request.getContextPath() + "/student/profile.jsp");
    }

    // -------------------------------------------------------
    // DELETE STUDENT (Librarian only)
    // -------------------------------------------------------
    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("librarian") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String usn = request.getParameter("usn");
        if (usn != null && !usn.trim().isEmpty()) {
            StudentDAO dao = new StudentDAO();
            boolean success = dao.deleteStudent(usn.trim());
            if (success) {
                session.setAttribute("success", "Student record deleted successfully.");
            } else {
                session.setAttribute("error", "Failed to delete student record.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/librarian/manageStudents.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
