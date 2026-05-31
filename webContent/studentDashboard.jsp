<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Student, dao.BookDAO, dao.BookIssueDAO, dao.BookReturnDAO, dao.BookRequestDAO, dao.PaymentDAO" %>
<%
    // ── SESSION GUARD ──
    Student student = (Student) session.getAttribute("student");
    if (student == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // ── Dashboard stats ──
    BookDAO        bookDAO     = new BookDAO();
    BookIssueDAO   issueDAO    = new BookIssueDAO();
    BookReturnDAO  returnDAO   = new BookReturnDAO();
    BookRequestDAO requestDAO  = new BookRequestDAO();
    PaymentDAO     payDAO      = new PaymentDAO();

    int totalBooks     = bookDAO.getTotalBooks();
    int availableBooks = bookDAO.getAvailableBooks();
    java.util.List<model.BookIssue> issues = issueDAO.getIssuesByUsn(student.getUsn());
    java.util.List<model.BookReturn> returns = returnDAO.getReturnsByUsn(student.getUsn());
    java.util.List<model.BookRequest> requests = requestDAO.getRequestsByUsn(student.getUsn());
    int myIssues       = issues.size();
    int myReturns      = returns.size();
    int myPendingRequests = 0;
    for (model.BookRequest br : requests) {
        if ("Pending".equals(br.getStatus())) {
            myPendingRequests++;
        }
    }
    double totalFines  = 0;
    java.util.List<model.Payment> myPayments = payDAO.getPaymentsByUsn(student.getUsn());
    for (model.Payment p : myPayments) totalFines += p.getAmount();

    // Flash messages
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
    <title>Student Dashboard — Library Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="layout">

    <!-- ═══════════════════════════════════════════
         SIDEBAR
    ═══════════════════════════════════════════ -->
    <aside class="sidebar">
        <div class="sidebar-brand">
            <div class="logo">
                <div class="logo-icon">📚</div>
                <div class="logo-text">LibraryMS <span>Student Portal</span></div>
            </div>
        </div>
        <nav class="sidebar-nav">
            <div class="nav-section-title">Main</div>
            <a href="studentDashboard.jsp"  class="nav-link active"><span class="nav-icon">🏠</span> Dashboard</a>
            <a href="searchBook.jsp"        class="nav-link"><span class="nav-icon">🔍</span> Search Books</a>

            <div class="nav-section-title">Transactions</div>
            <a href="studentDashboard.jsp" class="nav-link active"><span class="nav-icon">📚</span> Book History</a>

            <div class="nav-section-title">Account</div>
            <a href="profile.jsp"           class="nav-link"><span class="nav-icon">👤</span> My Profile</a>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="nav-link"><span class="nav-icon">🚪</span> Logout</a>
        </nav>
        <div class="sidebar-footer">
            <div class="user-info">
                <div class="avatar"><%= student.getStudentName().charAt(0) %></div>
                <div>
                    <div class="user-name"><%= student.getStudentName() %></div>
                    <div class="user-role"><%= student.getUsn() %> &bull; Sem <%= student.getSemester() %></div>
                </div>
            </div>
        </div>
    </aside>

    <!-- ═══════════════════════════════════════════
         MAIN CONTENT
    ═══════════════════════════════════════════ -->
    <div class="main-content">
        <div class="topbar">
            <div class="topbar-title">👋 Welcome back, <%= student.getStudentName() %>!</div>
            <div class="topbar-actions">
                <span class="badge badge-success">Student</span>
                <a href="${pageContext.request.contextPath}/LogoutServlet" class="btn btn-outline btn-sm">Logout</a>
            </div>
        </div>

        <div class="page-content">

            <!-- Flash messages -->
            <% if (successMsg != null) { %>
                <div class="alert alert-success" data-auto-dismiss>✅ <%= successMsg %></div>
            <% } %>
            <% if (errorMsg != null) { %>
                <div class="alert alert-danger" data-auto-dismiss>❌ <%= errorMsg %></div>
            <% } %>

            <!-- ── Stats Cards ── -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon cyan">📖</div>
                    <div class="stat-info">
                        <div class="stat-label">Books I Borrowed</div>
                        <div class="stat-value"><%= myIssues %></div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon amber">↩️</div>
                    <div class="stat-info">
                        <div class="stat-label">Books Returned</div>
                        <div class="stat-value"><%= myReturns %></div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon purple">⏳</div>
                    <div class="stat-info">
                        <div class="stat-label">Pending Requests</div>
                        <div class="stat-value"><%= myPendingRequests %></div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon red">💰</div>
                    <div class="stat-info">
                        <div class="stat-label">Total Fines Paid</div>
                        <div class="stat-value">₹<%= String.format("%.0f", totalFines) %></div>
                    </div>
                </div>
            </div>

            <!-- ── Two-column layout: Profile + Quick Actions ── -->
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-bottom:24px;">

                <!-- Student Info Card -->
                <div class="card">
                    <div class="card-header"><span class="card-title">👤 My Profile</span></div>
                    <div class="card-body">
                        <table style="width:100%;font-size:14px;">
                            <tr><td style="color:var(--text-muted);padding:7px 0;">USN</td><td style="font-weight:600;"><%= student.getUsn() %></td></tr>
                            <tr><td style="color:var(--text-muted);padding:7px 0;">Name</td><td style="font-weight:600;"><%= student.getStudentName() %></td></tr>
                            <tr><td style="color:var(--text-muted);padding:7px 0;">Branch</td><td style="font-weight:600;"><%= student.getBranch() %></td></tr>
                            <tr><td style="color:var(--text-muted);padding:7px 0;">Semester</td><td style="font-weight:600;"><%= student.getSemester() %></td></tr>
                            <tr><td style="color:var(--text-muted);padding:7px 0;">Phone</td><td style="font-weight:600;"><%= student.getPhoneNo() %></td></tr>
                        </table>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="card">
                    <div class="card-header"><span class="card-title">⚡ Quick Actions</span></div>
                    <div class="card-body" style="display:flex;flex-direction:column;gap:10px;">
                        <a href="searchBook.jsp" class="btn btn-primary">🔍 Search Books</a>
                        <a href="borrowBook.jsp" class="btn btn-success">📖 Borrow a Book</a>
                        <a href="returnBook.jsp" class="btn btn-warning">↩️ Return a Book</a>
                        <a href="payment.jsp"    class="btn btn-outline">💰 View Payments</a>
                    </div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">
                    <span class="card-title">📚 Book History</span>
                </div>
                <div class="card-body">
                    <div class="history-tabs" style="display:flex;gap:10px;margin-bottom:16px;flex-wrap:wrap;">
                        <button type="button" class="tab-button active" data-target="tabBorrow">Borrow Book</button>
                        <button type="button" class="tab-button" data-target="tabReturn">Return Book</button>
                        <button type="button" class="tab-button" data-target="tabPayment">Payments</button>
                        <button type="button" class="tab-button" data-target="tabRequests">Request History</button>
                    </div>

                    <div id="tabBorrow" class="history-panel">
                        <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;">
                            <div class="card">
                                <div class="card-header"><span class="card-title">📖 Borrow a Book</span></div>
                                <div class="card-body">
                                    <p class="text-muted" style="margin-bottom:16px;">
                                        Request a new book or search the catalog from here.
                                    </p>
                                    <div style="display:flex;gap:10px;flex-wrap:wrap;">
                                        <a href="borrowBook.jsp" class="btn btn-success">Request Book</a>
                                        <a href="searchBook.jsp" class="btn btn-outline">Search Books</a>
                                    </div>
                                </div>
                            </div>
                            <div class="card">
                                <div class="card-header"><span class="card-title">📚 Availability</span></div>
                                <div class="card-body">
                                    <p style="font-size:14px;color:var(--text-muted);margin-bottom:12px;">
                                        There are <strong><%= availableBooks %></strong> books currently available.
                                    </p>
                                    <p style="font-size:13px;color:var(--text-muted);">
                                        Pending book requests appear in Request History.
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div id="tabReturn" class="history-panel" style="display:none;">
                        <% if (issues.isEmpty()) { %>
                            <p class="text-muted">No currently issued books to return.</p>
                        <% } else { %>
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr><th>#</th><th>Book</th><th>Issue Date</th><th>Action</th></tr>
                                </thead>
                                <tbody>
                                <% int idx = 1;
                                   for (model.BookIssue bi : issues) { %>
                                    <tr>
                                        <td><%= idx++ %></td>
                                        <td><%= bi.getBookName() != null ? bi.getBookName() : "Book #" + bi.getBookId() %></td>
                                        <td><%= bi.getIssueDate() %></td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/ReturnRequestServlet" method="post" style="display:inline;">
                                                <input type="hidden" name="bookId" value="<%= bi.getBookId() %>">
                                                <button type="submit" class="btn btn-warning btn-sm"
                                                        onclick="return confirm('Submit a return request for this book?')">↩️ Request Return</button>
                                            </form>
                                        </td>
                                    </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } %>
                    </div>

                    <div id="tabPayment" class="history-panel" style="display:none;">
                        <div class="stats-grid" style="grid-template-columns:1fr 1fr; gap:16px; margin-bottom:18px;">
                            <div class="stat-card">
                                <div class="stat-icon red">💰</div>
                                <div class="stat-info">
                                    <div class="stat-label">Total Paid</div>
                                    <div class="stat-value">₹<%= String.format("%.2f", totalFines) %></div>
                                </div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-icon blue">📄</div>
                                <div class="stat-info">
                                    <div class="stat-label">Payment Transactions</div>
                                    <div class="stat-value"><%= myPayments.size() %></div>
                                </div>
                            </div>
                        </div>
                        <% if (myPayments.isEmpty()) { %>
                            <p class="text-muted">No payments recorded yet.</p>
                        <% } else { %>
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr><th>#</th><th>Amount</th><th>Type</th><th>Date</th></tr>
                                </thead>
                                <tbody>
                                <% int idxPay = 1;
                                   for (model.Payment p : myPayments) { %>
                                    <tr>
                                        <td><%= idxPay++ %></td>
                                        <td>₹<%= String.format("%.2f", p.getAmount()) %></td>
                                        <td><%= p.getPaymentType() %></td>
                                        <td><%= p.getPaymentDate() %></td>
                                    </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } %>
                        <div style="margin-top:16px;">
                            <a href="payment.jsp" class="btn btn-outline">View Full Payment History</a>
                        </div>
                    </div>

                    <div id="tabRequests" class="history-panel" style="display:none;">
                        <% if (requests.isEmpty()) { %>
                            <p class="text-muted">No request history available.</p>
                        <% } else { %>
                        <div class="table-wrapper">
                            <table>
                                <thead>
                                    <tr><th>#</th><th>Book</th><th>Status</th><th>Requested</th><th>Notes</th></tr>
                                </thead>
                                <tbody>
                                <% int idxReq = 1;
                                   for (model.BookRequest br : requests) { %>
                                    <tr>
                                        <td><%= idxReq++ %></td>
                                        <td><%= br.getBookName() != null ? br.getBookName() : "Book #" + br.getBookId() %></td>
                                        <td>
                                            <span class="badge <%= "Approved".equals(br.getStatus()) ? "badge-success" : ("Pending".equals(br.getStatus()) ? "badge-warning" : "badge-danger") %>">
                                                <%= br.getStatus() %>
                                            </span>
                                        </td>
                                        <td><%= br.getRequestDate() %></td>
                                        <td style="font-size:12px;color:var(--text-muted);">
                                            <%= br.getLibrarianComment() != null ? br.getLibrarianComment() : "—" %>
                                            <% if ("Approved".equals(br.getStatus())) { %>
                                                <div style="margin-top:6px;">
                                                    <a href="receipt.jsp?type=issue&requestId=<%= br.getRequestId() %>" class="btn btn-outline btn-sm">View Receipt</a>
                                                </div>
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
            </div>

        </div><!-- end page-content -->
    </div><!-- end main-content -->
</div>
<script>
    function activateTab(targetId) {
        document.querySelectorAll('.tab-button').forEach(b => b.classList.remove('active'));
        document.querySelectorAll('.history-panel').forEach(panel => panel.style.display = 'none');
        const button = document.querySelector('.tab-button[data-target="' + targetId + '"]');
        const panel = document.getElementById(targetId);
        if (button && panel) {
            button.classList.add('active');
            panel.style.display = 'block';
        }
    }

    document.querySelectorAll('.tab-button').forEach(btn => {
        btn.addEventListener('click', () => {
            activateTab(btn.getAttribute('data-target'));
        });
    });

    const params = new URLSearchParams(window.location.search);
    const selectedTab = params.get('tab');
    if (selectedTab) {
        activateTab('tab' + selectedTab.charAt(0).toUpperCase() + selectedTab.slice(1));
    }
</script>
<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
