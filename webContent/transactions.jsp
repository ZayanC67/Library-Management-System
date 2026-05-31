<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Librarian, model.BookIssue, model.BookReturn, model.Payment,
                 dao.BookIssueDAO, dao.BookReturnDAO, dao.PaymentDAO, java.util.List" %>
<%
    Librarian librarian = (Librarian) session.getAttribute("librarian");
    if (librarian == null) {
        response.sendRedirect(request.getContextPath() + "/librarianLogin.jsp");
        return;
    }
    BookIssueDAO  issueDAO  = new BookIssueDAO();
    BookReturnDAO returnDAO = new BookReturnDAO();
    PaymentDAO    payDAO    = new PaymentDAO();

    List<BookIssue>  allIssues  = issueDAO.getAllIssues();
    List<BookReturn> allReturns = returnDAO.getAllReturns();
    List<Payment>    allPayments= payDAO.getAllPayments();
    double totalFines = payDAO.getTotalFineCollected();

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
    <title>All Transactions — Library Management System</title>
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
            <a href="${pageContext.request.contextPath}/librarian/addBook.jsp" class="nav-link"><span class="nav-icon">➕</span> Add Book</a>
            <a href="${pageContext.request.contextPath}/librarian/manageBooks.jsp" class="nav-link"><span class="nav-icon">📚</span> Manage Books</a>
            <div class="nav-section-title">Student Management</div>
            <a href="${pageContext.request.contextPath}/librarian/manageStudents.jsp" class="nav-link"><span class="nav-icon">🎓</span> Manage Students</a>
            <div class="nav-section-title">Transactions</div>
            <a href="${pageContext.request.contextPath}/librarian/transactions.jsp" class="nav-link active"><span class="nav-icon">📊</span> All Transactions</a>
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
            <div class="topbar-title">📊 All Transactions</div>
            <div class="topbar-actions"><span class="badge badge-info">Librarian</span></div>
        </div>
        <div class="page-content">
            <% if (successMsg != null) { %><div class="alert alert-success" data-auto-dismiss>✅ <%= successMsg %></div><% } %>
            <% if (errorMsg   != null) { %><div class="alert alert-danger"  data-auto-dismiss>❌ <%= errorMsg %></div><% } %>

            <!-- Summary Stats -->
            <div class="stats-grid" style="grid-template-columns:repeat(3,1fr);margin-bottom:24px;">
                <div class="stat-card">
                    <div class="stat-icon blue">📖</div>
                    <div class="stat-info">
                        <div class="stat-label">Total Issues</div>
                        <div class="stat-value"><%= allIssues.size() %></div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon green">↩️</div>
                    <div class="stat-info">
                        <div class="stat-label">Total Returns</div>
                        <div class="stat-value"><%= allReturns.size() %></div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon red">💰</div>
                    <div class="stat-info">
                        <div class="stat-label">Total Fines</div>
                        <div class="stat-value">₹<%= String.format("%.2f", totalFines) %></div>
                    </div>
                </div>
            </div>

            <!-- Tab Navigation -->
            <div style="display:flex;gap:4px;background:var(--bg-dark);padding:4px;border-radius:8px;border:1px solid var(--border);margin-bottom:20px;width:fit-content;">
                <button onclick="showTab('issues')"  id="tabBtnIssues"  class="btn btn-primary btn-sm">📖 Issues (<%= allIssues.size() %>)</button>
                <button onclick="showTab('returns')" id="tabBtnReturns" class="btn btn-outline btn-sm">↩️ Returns (<%= allReturns.size() %>)</button>
                <button onclick="showTab('payments')" id="tabBtnPayments" class="btn btn-outline btn-sm">💰 Payments (<%= allPayments.size() %>)</button>
            </div>

            <!-- ISSUES TABLE -->
            <div id="tab-issues" class="card">
                <div class="card-header">
                    <span class="card-title">📖 Book Issue Records</span>
                    <input type="text" id="issueFilter" class="search-input" style="max-width:220px;"
                           placeholder="Filter..." onkeyup="filterTable('issueFilter','issueTable')">
                </div>
                <div class="card-body">
                    <% if (allIssues.isEmpty()) { %>
                        <p class="text-muted text-center" style="padding:20px;">No issue records found.</p>
                    <% } else { %>
                    <div class="table-wrapper">
                    <table id="issueTable">
                        <thead>
                            <tr><th>#</th><th>Issue ID</th><th>Book</th><th>Student</th><th>USN</th><th>Issue Date</th></tr>
                        </thead>
                        <tbody>
                        <% int i = 1; for (BookIssue bi : allIssues) { %>
                            <tr>
                                <td><%= i++ %></td>
                                <td><span class="badge badge-primary">#<%= bi.getIssueId() %></span></td>
                                <td style="font-weight:600;"><%= bi.getBookName() != null ? bi.getBookName() : "Book #"+bi.getBookId() %></td>
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

            <!-- RETURNS TABLE -->
            <div id="tab-returns" class="card hidden">
                <div class="card-header">
                    <span class="card-title">↩️ Book Return Records</span>
                    <input type="text" id="returnFilter" class="search-input" style="max-width:220px;"
                           placeholder="Filter..." onkeyup="filterTable('returnFilter','returnTable')">
                </div>
                <div class="card-body">
                    <% if (allReturns.isEmpty()) { %>
                        <p class="text-muted text-center" style="padding:20px;">No return records found.</p>
                    <% } else { %>
                    <div class="table-wrapper">
                    <table id="returnTable">
                        <thead>
                            <tr><th>#</th><th>Return ID</th><th>Book</th><th>Student</th><th>USN</th><th>Return Date</th></tr>
                        </thead>
                        <tbody>
                        <% int j = 1; for (BookReturn br : allReturns) { %>
                            <tr>
                                <td><%= j++ %></td>
                                <td><span class="badge badge-success">#<%= br.getReturnId() %></span></td>
                                <td style="font-weight:600;"><%= br.getBookName() != null ? br.getBookName() : "Book #"+br.getBookId() %></td>
                                <td><%= br.getStudentName() != null ? br.getStudentName() : "—" %></td>
                                <td style="font-size:12px;color:var(--text-muted);"><%= br.getStudentId() %></td>
                                <td><%= br.getReturnDate() %></td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                    </div>
                    <% } %>
                </div>
            </div>

            <!-- PAYMENTS TABLE -->
            <div id="tab-payments" class="card hidden">
                <div class="card-header">
                    <span class="card-title">💰 Payment Records</span>
                    <input type="text" id="payFilter" class="search-input" style="max-width:220px;"
                           placeholder="Filter..." onkeyup="filterTable('payFilter','payTable')">
                </div>
                <div class="card-body">
                    <% if (allPayments.isEmpty()) { %>
                        <p class="text-muted text-center" style="padding:20px;">No payment records found.</p>
                    <% } else { %>
                    <div class="table-wrapper">
                    <table id="payTable">
                        <thead>
                            <tr><th>#</th><th>Payment ID</th><th>Student</th><th>USN</th><th>Type</th><th>Amount</th><th>Date</th></tr>
                        </thead>
                        <tbody>
                        <% int k = 1; for (Payment p : allPayments) { %>
                            <tr>
                                <td><%= k++ %></td>
                                <td><span class="badge badge-warning">#<%= p.getPaymentId() %></span></td>
                                <td><%= p.getStudentName() != null ? p.getStudentName() : "—" %></td>
                                <td style="font-size:12px;color:var(--text-muted);"><%= p.getUsn() %></td>
                                <td><span class="badge <%= "Fine".equals(p.getPaymentType()) ? "badge-danger" : "badge-info" %>"><%= p.getPaymentType() %></span></td>
                                <td style="font-weight:700;color:var(--danger);">₹<%= String.format("%.2f", p.getAmount()) %></td>
                                <td><%= p.getPaymentDate() %></td>
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
<script>
function showTab(tab) {
    ['issues','returns','payments'].forEach(function(t) {
        document.getElementById('tab-'+t).classList.add('hidden');
        document.getElementById('tabBtn'+t.charAt(0).toUpperCase()+t.slice(1)).classList.remove('btn-primary');
        document.getElementById('tabBtn'+t.charAt(0).toUpperCase()+t.slice(1)).classList.add('btn-outline');
    });
    document.getElementById('tab-'+tab).classList.remove('hidden');
    var btn = document.getElementById('tabBtn'+tab.charAt(0).toUpperCase()+tab.slice(1));
    btn.classList.remove('btn-outline');
    btn.classList.add('btn-primary');
}
</script>
</body>
</html>
