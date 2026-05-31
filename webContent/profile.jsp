<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Student" %>
<%
    Student student = (Student) session.getAttribute("student");
    if (student == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
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
    <title>My Profile — Library Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="layout">
    <aside class="sidebar">
        <div class="sidebar-brand">
            <div class="logo">
                <div class="logo-icon">📚</div>
                <div class="logo-text">LibraryMS <span>Student Portal</span></div>
            </div>
        </div>
        <nav class="sidebar-nav">
            <div class="nav-section-title">Main</div>
            <a href="studentDashboard.jsp" class="nav-link"><span class="nav-icon">🏠</span> Dashboard</a>
            <a href="searchBook.jsp"       class="nav-link"><span class="nav-icon">🔍</span> Search Books</a>
            <div class="nav-section-title">Transactions</div>
            <a href="studentDashboard.jsp" class="nav-link"><span class="nav-icon">📚</span> Book History</a>
            <div class="nav-section-title">Account</div>
            <a href="profile.jsp"          class="nav-link active"><span class="nav-icon">👤</span> My Profile</a>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="nav-link"><span class="nav-icon">🚪</span> Logout</a>
        </nav>
        <div class="sidebar-footer">
            <div class="user-info">
                <div class="avatar"><%= student.getStudentName().charAt(0) %></div>
                <div>
                    <div class="user-name"><%= student.getStudentName() %></div>
                    <div class="user-role"><%= student.getUsn() %></div>
                </div>
            </div>
        </div>
    </aside>
    <div class="main-content">
        <div class="topbar">
            <div class="topbar-title">👤 My Profile</div>
            <div class="topbar-actions"><span class="badge badge-success">Student</span></div>
        </div>
        <div class="page-content">
            <% if (successMsg != null) { %><div class="alert alert-success" data-auto-dismiss>✅ <%= successMsg %></div><% } %>
            <% if (errorMsg   != null) { %><div class="alert alert-danger"  data-auto-dismiss>❌ <%= errorMsg %></div><% } %>

            <div style="display:grid;grid-template-columns:1fr 2fr;gap:20px;max-width:900px;">

                <!-- Avatar Panel -->
                <div class="card text-center">
                    <div class="card-body">
                        <div style="width:90px;height:90px;background:linear-gradient(135deg,var(--primary),var(--secondary));border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:40px;font-weight:800;color:white;margin:0 auto 16px;">
                            <%= student.getStudentName().charAt(0) %>
                        </div>
                        <div style="font-size:18px;font-weight:800;"><%= student.getStudentName() %></div>
                        <div style="font-size:13px;color:var(--text-muted);margin-top:4px;"><%= student.getUsn() %></div>
                        <div class="mt-2"><span class="badge badge-success">🎓 Student</span></div>
                        <div style="margin-top:16px;font-size:13px;color:var(--text-muted);">
                            <div>Branch: <strong><%= student.getBranch() %></strong></div>
                            <div>Semester: <strong><%= student.getSemester() %></strong></div>
                        </div>
                    </div>
                </div>

                <!-- Profile Information (Read-Only) -->
                <div class="card">
                    <div class="card-header"><span class="card-title">📋 Profile Information</span></div>
                    <div class="card-body">
                        <table style="width:100%;font-size:14px;">
                            <tr><td style="color:var(--text-muted);padding:10px 0;font-weight:600;">USN</td><td style="padding:10px 0;"><%= student.getUsn() %></td></tr>
                            <tr><td style="color:var(--text-muted);padding:10px 0;font-weight:600;">Full Name</td><td style="padding:10px 0;"><%= student.getStudentName() %></td></tr>
                            <tr><td style="color:var(--text-muted);padding:10px 0;font-weight:600;">Branch</td><td style="padding:10px 0;"><%= student.getBranch() %></td></tr>
                            <tr><td style="color:var(--text-muted);padding:10px 0;font-weight:600;">Semester</td><td style="padding:10px 0;"><%= student.getSemester() %></td></tr>
                            <tr><td style="color:var(--text-muted);padding:10px 0;font-weight:600;">Phone Number</td><td style="padding:10px 0;"><%= student.getPhoneNo() %></td></tr>
                        </table>
                        <div style="margin-top:16px;padding-top:16px;border-top:1px solid var(--border-color);color:var(--text-muted);font-size:13px;">
                            ℹ️ Your profile information is read-only. Contact the librarian if you need to update your details.
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
