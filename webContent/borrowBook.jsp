<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Student, model.Book, dao.BookDAO, dao.BookRequestDAO, java.util.List, java.util.HashSet, java.util.Set" %>
<%
    Student student = (Student) session.getAttribute("student");
    if (student == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    BookDAO bookDAO = new BookDAO();
    BookRequestDAO requestDAO = new BookRequestDAO();
    Set<Integer> requestedBookIds = new HashSet<>();
    java.util.List<model.BookRequest> myRequests = requestDAO.getRequestsByUsn(student.getUsn());
    for (model.BookRequest br : myRequests) {
        if ("Pending".equals(br.getStatus())) {
            requestedBookIds.add(br.getBookId());
        }
    }
    List<Book> availableBooks = bookDAO.searchBooks("");
    // filter only available
    java.util.List<Book> onlyAvailable = new java.util.ArrayList<>();
    for (Book b : bookDAO.getAllBooks()) {
        if ("Available".equals(b.getAvailabilityStatus())) onlyAvailable.add(b);
    }

    String preBookId = request.getParameter("bookId") != null ? request.getParameter("bookId") : "";

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
    <title>Borrow Book — Library Management System</title>
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
            <a href="profile.jsp"          class="nav-link"><span class="nav-icon">👤</span> My Profile</a>
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
            <div class="topbar-title">📖 Borrow a Book</div>
            <div class="topbar-actions"><span class="badge badge-success">Student</span></div>
        </div>
        <div class="page-content">
            <% if (successMsg != null) { %><div class="alert alert-success" data-auto-dismiss>✅ <%= successMsg %></div><% } %>
            <% if (errorMsg   != null) { %><div class="alert alert-danger"  data-auto-dismiss>❌ <%= errorMsg %></div><% } %>

            <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;">

                <!-- Request Form -->
                <div class="card">
                    <div class="card-header"><span class="card-title">📖 Request a Book</span></div>
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/RequestBookServlet" method="post"
                              onsubmit="return validateIssueReturn('borrowBookId', null)">
                            <input type="hidden" name="redirect" value="/student/studentDashboard.jsp?tab=requests">
                            <div class="form-group">
                                <label class="form-label">Select Book</label>
                                <select id="borrowBookId" name="bookId" class="form-control" required>
                                    <option value="">-- Select an Available Book --</option>
                                    <% for (Book b : onlyAvailable) { %>
                                        <option value="<%= b.getBookId() %>"
                                            <%= preBookId.equals(String.valueOf(b.getBookId())) ? "selected" : "" %>
                                            <%= requestedBookIds.contains(b.getBookId()) ? "disabled" : "" %>>
                                            #<%= b.getBookId() %> — <%= b.getBookName() %> (<%= b.getAuthorName() %>)
                                            <%= requestedBookIds.contains(b.getBookId()) ? " (Requested)" : "" %>
                                        </option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Your USN</label>
                                <input type="text" class="form-control"
                                       value="<%= student.getUsn() %>" disabled
                                       style="opacity:0.6;cursor:not-allowed;">
                                <small class="text-muted">Your USN is auto-filled from your session.</small>
                            </div>
                            <div class="form-group">
                                <label class="form-label">Issue Date</label>
                                <input type="text" class="form-control" value="Today (Auto)" disabled style="opacity:0.6;">
                            </div>
                            <div style="background:rgba(245,158,11,0.1);border:1px solid rgba(245,158,11,0.3);border-radius:8px;padding:14px;margin-bottom:16px;">
                                <p style="font-size:13px;color:#fbbf24;font-weight:600;">📌 Important Note</p>
                                <p style="font-size:12px;color:var(--text-muted);margin-top:4px;">
                                    Books must be returned within <strong>14 days</strong>. After that,
                                    a fine of <strong>₹2 per day</strong> will be charged.
                                </p>
                            </div>
                            <button type="submit" class="btn btn-success w-100" style="justify-content:center;">
                                📘 Request Book
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Available Books Quick List -->
                <div class="card">
                    <div class="card-header">
                        <span class="card-title">✅ Available Books (<%= onlyAvailable.size() %>)</span>
                    </div>
                    <div class="card-body" style="max-height:450px;overflow-y:auto;">
                        <% if (onlyAvailable.isEmpty()) { %>
                            <p class="text-muted text-center">No books currently available.</p>
                        <% } else {
                               for (Book b : onlyAvailable) { %>
                            <div style="display:flex;justify-content:space-between;align-items:center;padding:10px 0;border-bottom:1px solid var(--border);">
                                <div>
                                    <div style="font-weight:600;font-size:13px;"><%= b.getBookName() %></div>
                                    <div style="font-size:12px;color:var(--text-muted);"><%= b.getAuthorName() %> &bull; ID #<%= b.getBookId() %></div>
                                </div>
                                <span class="badge badge-success">Available</span>
                            </div>
                        <% }} %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
