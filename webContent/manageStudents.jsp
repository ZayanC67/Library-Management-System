<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Librarian, model.Student, dao.StudentDAO, java.util.List" %>
<%
    Librarian librarian = (Librarian) session.getAttribute("librarian");
    if (librarian == null) {
        response.sendRedirect(request.getContextPath() + "/librarianLogin.jsp");
        return;
    }
    StudentDAO studentDAO = new StudentDAO();
    List<Student> students = studentDAO.getAllStudents();

    String successMsg = (String) session.getAttribute("success");
    String errorMsg   = (String) session.getAttribute("error");
    if (successMsg != null) session.removeAttribute("success");
    if (errorMsg   != null) session.removeAttribute("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Students — Library Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="layout">
    <aside class="sidebar">
        <div class="sidebar-brand">
            <div class="logo">
                <div class="logo-icon">📋</div>
                <div class="logo-text">LibraryMS <span>Librarian Portal</span></div>
            </div>
        </div>
        <nav class="sidebar-nav">
            <div class="nav-section-title">Dashboard</div>
            <a href="librarianDashboard.jsp"  class="nav-link"><span class="nav-icon">🏠</span> Dashboard</a>
            <div class="nav-section-title">Book Management</div>
            <a href="addBook.jsp"             class="nav-link"><span class="nav-icon">➕</span> Add Book</a>
            <a href="manageBooks.jsp"          class="nav-link"><span class="nav-icon">📚</span> Manage Books</a>
            <div class="nav-section-title">Student Management</div>
            <a href="manageStudents.jsp"       class="nav-link active"><span class="nav-icon">🎓</span> Manage Students</a>
            <div class="nav-section-title">Transactions</div>
            <a href="transactions.jsp"         class="nav-link"><span class="nav-icon">📊</span> All Transactions</a>
            <div class="nav-section-title">Account</div>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="nav-link"><span class="nav-icon">🚪</span> Logout</a>
        </nav>
        <div class="sidebar-footer">
            <div class="user-info">
                <div class="avatar"><%= librarian.getLibrarianName().charAt(0) %></div>
                <div>
                    <div class="user-name"><%= librarian.getLibrarianName() %></div>
                    <div class="user-role">Librarian</div>
                </div>
            </div>
        </div>
    </aside>
    <div class="main-content">
        <div class="topbar">
            <div class="topbar-title">🎓 Manage Students</div>
            <div class="topbar-actions">
                <span class="badge badge-info">Librarian</span>
            </div>
        </div>
        <div class="page-content">
            <% if (successMsg != null) { %><div class="alert alert-success" data-auto-dismiss>✅ <%= successMsg %></div><% } %>
            <% if (errorMsg   != null) { %><div class="alert alert-danger"  data-auto-dismiss>❌ <%= errorMsg %></div><% } %>

            <!-- Live Filter -->
            <div class="card mb-3">
                <div class="card-body">
                    <input type="text" id="stuFilter" class="search-input"
                           placeholder="Filter students by name, USN, branch..."
                           onkeyup="filterTable('stuFilter','studentTable')">
                </div>
            </div>

            <!-- Students Table -->
            <div class="card">
                <div class="card-header">
                    <span class="card-title">🎓 Registered Students (<%= students.size() %>)</span>
                </div>
                <div class="card-body">
                    <% if (students.isEmpty()) { %>
                        <p class="text-muted text-center" style="padding:30px;">No students registered yet.</p>
                    <% } else { %>
                    <div class="table-wrapper">
                    <table id="studentTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>USN</th>
                                <th>Name</th>
                                <th>Branch</th>
                                <th>Semester</th>
                                <th>Phone</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% int i = 1; for (Student s : students) { %>
                            <tr>
                                <td><%= i++ %></td>
                                <td><span class="badge badge-primary"><%= s.getUsn() %></span></td>
                                <td style="font-weight:600;">
                                    <div style="display:flex;align-items:center;gap:10px;">
                                        <div style="width:32px;height:32px;background:linear-gradient(135deg,var(--primary),var(--secondary));border-radius:50%;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:13px;flex-shrink:0;">
                                            <%= s.getStudentName().charAt(0) %>
                                        </div>
                                        <%= s.getStudentName() %>
                                    </div>
                                </td>
                                <td><span class="badge badge-info"><%= s.getBranch() %></span></td>
                                <td>Sem <%= s.getSemester() %></td>
                                <td style="color:var(--text-muted);font-size:13px;"><%= s.getPhoneNo() %></td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/StudentServlet"
                                          method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="usn"    value="<%= s.getUsn() %>">
                                        <button type="submit" class="btn btn-danger btn-sm"
                                                onclick="return confirmDelete('Delete student <%= s.getUsn() %>?')">
                                            🗑️ Delete
                                        </button>
                                    </form>
                                </td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
