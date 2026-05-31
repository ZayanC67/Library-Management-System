<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Student, model.BookIssue, dao.BookIssueDAO, dao.BookReturnDAO, dao.ReturnRequestDAO, model.ReturnRequest, java.util.List" %>
<%
    Student student = (Student) session.getAttribute("student");
    if (student == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    BookIssueDAO  issueDAO         = new BookIssueDAO();
    BookReturnDAO returnDAO        = new BookReturnDAO();
    ReturnRequestDAO returnReqDAO  = new ReturnRequestDAO();
    List<BookIssue> myIssues       = issueDAO.getIssuesByUsn(student.getUsn());
    List<ReturnRequest> myRequests = returnReqDAO.getRequestsByUsn(student.getUsn());

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
    <title>Return Book — Library Management System</title>
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
            <div class="topbar-title">↩️ Return a Book</div>
            <div class="topbar-actions"><span class="badge badge-success">Student</span></div>
        </div>
        <div class="page-content">
            <% if (successMsg != null) { %><div class="alert alert-success" data-auto-dismiss>✅ <%= successMsg %></div><% } %>
            <% if (errorMsg   != null) { %><div class="alert alert-danger"  data-auto-dismiss>❌ <%= errorMsg %></div><% } %>

            <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;">

                <!-- Return Form -->
                <div class="card">
                    <div class="card-header"><span class="card-title">↩️ Return Book</span></div>
                    <div class="card-body">
                        <% if (myIssues.isEmpty()) { %>
                            <div class="alert alert-info">📚 You have no books currently borrowed to return.</div>
                            <a href="borrowBook.jsp" class="btn btn-primary">📖 Borrow a Book</a>
                        <% } else { %>
                        <form action="${pageContext.request.contextPath}/ReturnRequestServlet" method="post"
                              onsubmit="return validateIssueReturn('returnBookId', null)">
                            <div class="form-group">
                                <label class="form-label">Select Book to Return</label>
                                <select name="bookId" class="form-control" required id="returnBookId">
                                    <option value="">-- Select a Book --</option>
                                    <% for (BookIssue bi : myIssues) { %>
                                        <option value="<%= bi.getBookId() %>">
                                            #<%= bi.getBookId() %> — <%= bi.getBookName() != null ? bi.getBookName() : "Book #"+bi.getBookId() %>
                                            (Issued: <%= bi.getIssueDate() %>)
                                        </option>
                                    <% } %>
                                </select>
                            </div>
                            <div style="background:rgba(239,68,68,0.1);border:1px solid rgba(239,68,68,0.3);border-radius:8px;padding:14px;margin-bottom:16px;">
                                <p style="font-size:13px;color:#f87171;font-weight:600;">⚠️ Fine Policy</p>
                                <p style="font-size:12px;color:var(--text-muted);margin-top:4px;">
                                    If your book is overdue (more than <strong>14 days</strong>),
                                    a fine of <strong>₹2 per extra day</strong> will be automatically charged
                                    and recorded in your payment history.
                                </p>
                            </div>
                            <button type="submit" class="btn btn-warning w-100" style="justify-content:center;"
                                    onclick="return confirm('Submit return request to librarian?')">
                                ↩️ Submit Return Request
                            </button>
                        </form>
                        <% } %>
                    </div>
                </div>

                <!-- Pending Return Requests -->
                <div class="card">
                    <div class="card-header"><span class="card-title">⏳ My Return Requests</span></div>
                    <div class="card-body" style="max-height:250px;overflow-y:auto;">
                        <% if (myRequests.isEmpty()) { %>
                            <p class="text-muted text-center">No return requests submitted yet.</p>
                        <% } else { %>
                            <div class="table-wrapper">
                                <table>
                                    <thead>
                                        <tr><th>#</th><th>Book</th><th>Status</th><th>Requested</th><th>Receipt</th></tr>
                                    </thead>
                                    <tbody>
                                    <% int idxReq = 1;
                                       for (ReturnRequest rr : myRequests) { %>
                                        <tr>
                                            <td><%= idxReq++ %></td>
                                            <td><%= rr.getBookName() != null ? rr.getBookName() : "Book #" + rr.getBookId() %></td>
                                            <td><span class="badge <%= "Pending".equals(rr.getStatus()) ? "badge-warning" : "badge-success" %>"><%= rr.getStatus() %></span></td>
                                            <td><%= rr.getRequestDate() %></td>
                                            <td>
                                                <% if ("Approved".equals(rr.getStatus())) { %>
                                                    <a href="receipt.jsp?type=return&requestId=<%= rr.getRequestId() %>" class="btn btn-outline btn-sm">View Receipt</a>
                                                <% } else { %>
                                                    —
                                                <% } %>
                                            </td>
                                        </tr>
                                    <% } %>
                                    </tbody>
                                </table>
                            </div>
                        <% } %>
                    </div>
                </div>

                <!-- My Currently Borrowed Books -->
                <div class="card">
                    <div class="card-header"><span class="card-title">📖 Currently Borrowed (<%= myIssues.size() %>)</span></div>
                    <div class="card-body" style="max-height:420px;overflow-y:auto;">
                        <% if (myIssues.isEmpty()) { %>
                            <p class="text-muted text-center">No books currently borrowed.</p>
                        <% } else {
                               long now = System.currentTimeMillis();
                               for (BookIssue bi : myIssues) {
                                   long days = (now - bi.getIssueDate().getTime()) / (1000L*60*60*24);
                                   boolean overdue = days > 14;
                        %>
                            <div style="padding:12px 0;border-bottom:1px solid var(--border);">
                                <div style="display:flex;justify-content:space-between;align-items:center;">
                                    <div>
                                        <div style="font-weight:600;font-size:13px;">
                                            <%= bi.getBookName() != null ? bi.getBookName() : "Book #"+bi.getBookId() %>
                                        </div>
                                        <div style="font-size:12px;color:var(--text-muted);">
                                            Issued: <%= bi.getIssueDate() %> &bull; <%= days %> days ago
                                        </div>
                                    </div>
                                    <span class="badge <%= overdue ? "badge-danger" : "badge-success" %>">
                                        <%= overdue ? "⚠️ Overdue" : "✅ On Time" %>
                                    </span>
                                </div>
                                <% if (overdue) { %>
                                    <div style="font-size:11px;color:#f87171;margin-top:4px;">
                                        Fine: ₹<%= String.format("%.2f", (days - 14) * 2.0) %>
                                    </div>
                                <% } %>
                            </div>
                        <% }} %>
                    </div>
                </div>
            </div>

            <!-- Return History -->
            <div class="card mt-3">
                <div class="card-header"><span class="card-title">📋 My Return History</span></div>
                <div class="card-body">
                    <%
                        java.util.List<model.BookReturn> returns = returnDAO.getReturnsByUsn(student.getUsn());
                        if (returns.isEmpty()) {
                    %>
                        <p class="text-muted text-center" style="padding:20px;">No return history found.</p>
                    <% } else { %>
                    <div class="table-wrapper">
                    <table>
                        <thead>
                            <tr><th>#</th><th>Book Name</th><th>Return Date</th><th>Status</th></tr>
                        </thead>
                        <tbody>
                        <% int i = 1; for (model.BookReturn br : returns) { %>
                            <tr>
                                <td><%= i++ %></td>
                                <td style="font-weight:600;"><%= br.getBookName() != null ? br.getBookName() : "Book #"+br.getBookId() %></td>
                                <td><%= br.getReturnDate() %></td>
                                <td><span class="badge badge-success">✅ Returned</span></td>
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
