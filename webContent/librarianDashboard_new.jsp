<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Librarian, dao.BookDAO, dao.BookIssueDAO, dao.BookReturnDAO, dao.BookRequestDAO, dao.ReturnRequestDAO, dao.LibrarianDAO, dao.PaymentDAO, dao.StudentDAO" %>
<%
    Librarian librarian = (Librarian) session.getAttribute("librarian");
    if (librarian == null) {
        response.sendRedirect(request.getContextPath() + "/librarianLogin.jsp");
        return;
    }
    BookDAO         bookDAO          = new BookDAO();
    BookIssueDAO    issueDAO         = new BookIssueDAO();
    BookReturnDAO   bookReturnDAO    = new BookReturnDAO();
    BookRequestDAO  requestDAO       = new BookRequestDAO();
    ReturnRequestDAO returnRequestDAO = new ReturnRequestDAO();
    LibrarianDAO    libDAO           = new LibrarianDAO();
    PaymentDAO      payDAO           = new PaymentDAO();

    int totalBooks     = bookDAO.getTotalBooks();
    int availBooks     = bookDAO.getAvailableBooks();
    int issuedBooks    = bookDAO.getIssuedBooks();
    int totalStudents  = libDAO.getTotalStudents();
    int totalIssues    = issueDAO.getTotalIssues();
    double totalFines  = payDAO.getTotalFineCollected();
    java.util.List<model.BookRequest> pendingBookRequests = requestDAO.getPendingRequests();
    java.util.List<model.ReturnRequest> pendingReturnRequests = returnRequestDAO.getPendingReturnRequests();

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
    <title>Librarian Dashboard — Library Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="layout">

    <!-- ═══════════════════════════════
         SIDEBAR - LIBRARIAN
    ═══════════════════════════════ -->
    <aside class="sidebar">
        <div class="sidebar-brand">
            <div class="logo">
                <div class="logo-icon">📋</div>
                <div class="logo-text">LibraryMS <span>Librarian Portal</span></div>
            </div>
        </div>
        <nav class="sidebar-nav">
            <div class="nav-section-title">Dashboard</div>
            <a href="${pageContext.request.contextPath}/librarian/librarianDashboard.jsp" class="nav-link active"><span class="nav-icon">🏠</span> Dashboard</a>

            <div class="nav-section-title">Book Management</div>
            <a href="${pageContext.request.contextPath}/librarian/addBook.jsp" class="nav-link"><span class="nav-icon">➕</span> Add Book</a>
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

    <!-- ═══════════════════════════════
         MAIN CONTENT
    ═══════════════════════════════ -->
    <div class="main-content">
        <div class="topbar">
            <div class="topbar-title">👋 Welcome, <%= librarian.getLibrarianName() %>!</div>
            <div class="topbar-actions">
                <span class="badge badge-info">Librarian</span>
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-outline btn-sm">Logout</a>
            </div>
        </div>

        <div class="page-content">
            <% if (successMsg != null) { %><div class="alert alert-success" data-auto-dismiss>✅ <%= successMsg %></div><% } %>
            <% if (errorMsg   != null) { %><div class="alert alert-danger"  data-auto-dismiss>❌ <%= errorMsg %></div><% } %>

            <!-- Stats Grid -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon blue">📚</div>
                    <div class="stat-info">
                        <div class="stat-label">Total Books</div>
                        <div class="stat-value"><%= totalBooks %></div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon green">✅</div>
                    <div class="stat-info">
                        <div class="stat-label">Available</div>
                        <div class="stat-value"><%= availBooks %></div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon amber">📖</div>
                    <div class="stat-info">
                        <div class="stat-label">Issued Books</div>
                        <div class="stat-value"><%= issuedBooks %></div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon cyan">🎓</div>
                    <div class="stat-info">
                        <div class="stat-label">Students</div>
                        <div class="stat-value"><%= totalStudents %></div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon blue">🔄</div>
                    <div class="stat-info">
                        <div class="stat-label">Total Issues</div>
                        <div class="stat-value"><%= totalIssues %></div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon orange">⏳</div>
                    <div class="stat-info">
                        <div class="stat-label">Pending Requests</div>
                        <div class="stat-value"><%= pendingBookRequests.size() + pendingReturnRequests.size() %></div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon red">💰</div>
                    <div class="stat-info">
                        <div class="stat-label">Fines Collected</div>
                        <div class="stat-value">₹<%= String.format("%.0f", totalFines) %></div>
                    </div>
                </div>
            </div>

            <!-- Pending Requests -->
             <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-bottom:24px;">
                <div class="card">
                    <div class="card-header"><span class="card-title">⏳ Pending Book Requests</span></div>
                    <div class="card-body" style="max-height:360px;overflow-y:auto;">
                        <% if (pendingBookRequests.isEmpty()) { %>
                            <p class="text-muted text-center">No pending book requests.</p>
                        <% } else { %>
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr><th>#</th><th>Book</th><th>Student</th><th>Requested</th><th>Action</th></tr>
                                </thead>
                                <tbody>
                                <% int idxReq = 1;
                                   for (model.BookRequest br : pendingBookRequests) { %>
                                    <tr>
                                        <td><%= idxReq++ %></td>
                                        <td><%= br.getBookName() != null ? br.getBookName() : "Book #" + br.getBookId() %></td>
                                        <td><%= br.getStudentName() != null ? br.getStudentName() : br.getUsn() %></td>
                                        <td><%= br.getRequestDate() %></td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/LibrarianRequestServlet" method="post" style="display:flex;gap:6px;flex-wrap:wrap;">
                                                <input type="hidden" name="requestType" value="book">
                                                <input type="hidden" name="requestId" value="<%= br.getRequestId() %>">
                                                <button name="action" value="approve" class="btn btn-success btn-sm">Approve</button>
                                                <button name="action" value="reject" class="btn btn-danger btn-sm">Reject</button>
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

                <div class="card">
                    <div class="card-header"><span class="card-title">⏳ Pending Return Requests</span></div>
                    <div class="card-body" style="max-height:360px;overflow-y:auto;">
                        <% if (pendingReturnRequests.isEmpty()) { %>
                            <p class="text-muted text-center">No pending return requests.</p>
                        <% } else { %>
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr><th>#</th><th>Book</th><th>Student</th><th>Requested</th><th>Action</th></tr>
                                </thead>
                                <tbody>
                                <% int idxRet = 1;
                                   for (model.ReturnRequest rr : pendingReturnRequests) { %>
                                    <tr>
                                        <td><%= idxRet++ %></td>
                                        <td><%= rr.getBookName() != null ? rr.getBookName() : "Book #" + rr.getBookId() %></td>
                                        <td><%= rr.getStudentName() != null ? rr.getStudentName() : rr.getUsn() %></td>
                                        <td><%= rr.getRequestDate() %></td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/LibrarianRequestServlet" method="post" style="display:flex;gap:6px;flex-wrap:wrap;">
                                                <input type="hidden" name="requestType" value="return">
                                                <input type="hidden" name="requestId" value="<%= rr.getRequestId() %>">
                                                <button name="action" value="approve" class="btn btn-success btn-sm">Approve</button>
                                                <button name="action" value="reject" class="btn btn-danger btn-sm">Reject</button>
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

            <!-- Quick Links -->
            <div class="card">
                <div class="card-header"><span class="card-title">⚡ Quick Actions</span></div>
                <div class="card-body" style="display:flex;flex-wrap:wrap;gap:12px;">
                    <a href="${pageContext.request.contextPath}/librarian/addBook.jsp" class="btn btn-primary">➕ Add New Book</a>
                    <a href="${pageContext.request.contextPath}/librarian/manageBooks.jsp" class="btn btn-outline">📚 Manage Books</a>
                    <a href="${pageContext.request.contextPath}/librarian/manageStudents.jsp" class="btn btn-outline">🎓 Manage Students</a>
                    <a href="${pageContext.request.contextPath}/librarian/transactions.jsp" class="btn btn-outline">📊 View Transactions</a>
                </div>
            </div>

            <!-- Recent Issues Table -->
            <div class="card mt-3">
                <div class="card-header">
                    <span class="card-title">🔄 Recent Book Issues</span>
                    <a href="transactions.jsp" class="btn btn-outline btn-sm">View All</a>
                </div>
                <div class="card-body">
                    <%
                        java.util.List<model.BookIssue> recentIssues = issueDAO.getAllIssues();
                        int limit = Math.min(recentIssues.size(), 5);
                    %>
                    <% if (recentIssues.isEmpty()) { %>
                        <p class="text-muted text-center" style="padding:20px;">No issue transactions yet.</p>
                    <% } else { %>
                    <div class="table-wrapper">
                    <table>
                        <thead>
                            <tr><th>#</th><th>Issue ID</th><th>Book</th><th>Student</th><th>USN</th><th>Issue Date</th></tr>
                        </thead>
                        <tbody>
                        <% for (int i = 0; i < limit; i++) {
                               model.BookIssue bi = recentIssues.get(i); %>
                            <tr>
                                <td><%= i+1 %></td>
                                <td><span class="badge badge-primary">#<%= bi.getIssueId() %></span></td>
                                <td><%= bi.getBookName() != null ? bi.getBookName() : "Book #"+bi.getBookId() %></td>
                                <td><%= bi.getStudentName() != null ? bi.getStudentName() : "—" %></td>
                                <td style="font-size:12px;color:var(--text-muted);"><%= bi.getStudentId() %></td>
                                <td><%= bi.getIssueDate() %></td>
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
