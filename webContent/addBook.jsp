<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Librarian" %>
<%
    Librarian librarian = (Librarian) session.getAttribute("librarian");
    if (librarian == null) {
        response.sendRedirect(request.getContextPath() + "/librarianLogin.jsp");
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
    <title>Add Book — Library Management System</title>
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
            <a href="${pageContext.request.contextPath}/librarian/librarianDashboard.jsp" class="nav-link"><span class="nav-icon">🏠</span> Dashboard</a>
            <div class="nav-section-title">Book Management</div>
            <a href="${pageContext.request.contextPath}/librarian/addBook.jsp" class="nav-link active"><span class="nav-icon">➕</span> Add Book</a>
            <a href="${pageContext.request.contextPath}/librarian/manageBooks.jsp" class="nav-link"><span class="nav-icon">📚</span> Manage Books</a>
            <div class="nav-section-title">Student Management</div>
            <a href="${pageContext.request.contextPath}/librarian/manageStudents.jsp" class="nav-link"><span class="nav-icon">🎓</span> Manage Students</a>
            <div class="nav-section-title">Transactions</div>
            <a href="${pageContext.request.contextPath}/librarian/transactions.jsp" class="nav-link"><span class="nav-icon">📊</span> All Transactions</a>
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
            <div class="topbar-title">➕ Add New Book</div>
            <div class="topbar-actions">
                <span class="badge badge-info">Librarian</span>
                <a href="manageBooks.jsp" class="btn btn-outline btn-sm">📚 View All Books</a>
            </div>
        </div>
        <div class="page-content">
            <% if (successMsg != null) { %><div class="alert alert-success" data-auto-dismiss>✅ <%= successMsg %></div><% } %>
            <% if (errorMsg   != null) { %><div class="alert alert-danger"  data-auto-dismiss>❌ <%= errorMsg %></div><% } %>

            <div style="max-width:600px;">
                <div class="card">
                    <div class="card-header"><span class="card-title">📚 Book Information</span></div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/AddBookServlet" method="post"
                              onsubmit="return validateAddBook()">

                            <div class="form-group">
                                <label class="form-label" for="bookName">Book Name *</label>
                                <input type="text" id="bookName" name="bookName" class="form-control"
                                       placeholder="e.g. Introduction to Algorithms" required>
                            </div>

                            <div class="form-group">
                                <label class="form-label" for="authorName">Author Name *</label>
                                <input type="text" id="authorName" name="authorName" class="form-control"
                                       placeholder="e.g. Thomas H. Cormen" required>
                            </div>

                            <div style="display:flex;gap:12px;">
                                <button type="submit" class="btn btn-primary">➕ Add Book</button>
                                <button type="reset"  class="btn btn-outline">🔄 Reset</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Tips -->
                <div class="card mt-3" style="border-color:rgba(79,70,229,0.3);">
                    <div class="card-body">
                        <p style="font-size:13px;font-weight:600;color:var(--primary-light);margin-bottom:8px;">📌 Tips</p>
                        <ul style="font-size:13px;color:var(--text-muted);padding-left:18px;line-height:1.8;">
                            <li>Book ID is auto-generated by the system.</li>
                            <li>Set status to <strong>Available</strong> for new books by default.</li>
                            <li>Duplicate book names are allowed (different editions).</li>
                            <li>After adding, go to <a href="manageBooks.jsp">Manage Books</a> to view all books.</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
