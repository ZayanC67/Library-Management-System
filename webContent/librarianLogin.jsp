<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Librarian Secure Login — Library Management System.">
    <title>Librarian Admin Login — Library Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body class="librarian-body">
<div class="login-page">
    <div class="login-container">

        <!-- Header -->
        <div class="login-header">
            <div class="login-logo" style="background: linear-gradient(135deg, #06b6d4, #0891b2); color: white; font-weight: bold; box-shadow: 0 8px 32px rgba(6, 182, 212, 0.4);">📋</div>
            <h1 class="librarian-text-light">Librarian Admin Panel</h1>
            <p class="librarian-text-muted">Enter administrative credentials to access library controls</p>
        </div>

        <!-- Flash Messages -->
        <%
            String successMsg = (String) session.getAttribute("success");
            String errorMsg   = request.getAttribute("error") != null
                                ? (String) request.getAttribute("error")
                                : (String) session.getAttribute("error");
            if (successMsg != null) session.removeAttribute("success");
            if (session.getAttribute("error") != null) session.removeAttribute("error");
        %>
        <% if (successMsg != null) { %>
            <div class="alert alert-success" data-auto-dismiss>✅ <%= successMsg %></div>
        <% } %>
        <% if (errorMsg != null) { %>
            <div class="alert alert-danger" data-auto-dismiss>❌ <%= errorMsg %></div>
        <% } %>
        <% if ("true".equals(request.getParameter("logout"))) { %>
            <div class="alert alert-info" data-auto-dismiss>👋 Administrative session ended successfully.</div>
        <% } %>

        <!-- Login Card -->
        <div class="login-card librarian-login-card">

            <div id="form-librarian" class="role-form">
                <form action="LoginServlet" method="post" onsubmit="return validateLibrarianLogin()">
                    <input type="hidden" name="role" value="librarian">
                    
                    <div class="form-group">
                        <label class="form-label librarian-text-light" for="librarianUsername">Librarian Username</label>
                        <input type="text" id="librarianUsername" name="username"
                               class="form-control librarian-form-control" placeholder="e.g. admin" required>
                    </div>
                    
                    <div class="form-group">
                        <label class="form-label librarian-text-light" for="librarianPassword">Security Password</label>
                        <input type="password" id="librarianPassword" name="password"
                               class="form-control librarian-form-control" placeholder="Enter password" required>
                    </div>
                    
                    <button type="submit" class="btn w-100" style="justify-content:center; background: linear-gradient(135deg, #06b6d4, #0891b2); color: white;">
                        🔑 Secure Authorize
                    </button>
                </form>
                
                <p class="text-center librarian-text-muted mt-3" style="font-size:12px; margin-bottom:0;">
                    Warning: Authorized access only. All actions are audited.
                </p>
            </div>

        </div><!-- end login-card -->

        <p class="text-center librarian-text-muted mt-3" style="font-size:12px;">
            <a href="index.jsp" class="librarian-text-muted" style="text-decoration: underline;">← Back to Main Page</a>
        </p>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
