<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Student, dao.BookRequestDAO, dao.ReturnRequestDAO, dao.ReceiptDAO, model.BookRequest, model.ReturnRequest, model.IssueReceipt, model.ReturnReceipt" %>
<%
    Student student = (Student) session.getAttribute("student");
    if (student == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String type = request.getParameter("type");
    String requestIdParam = request.getParameter("requestId");
    boolean invalid = false;
    BookRequest bookRequest = null;
    ReturnRequest returnRequest = null;
    IssueReceipt issueReceipt = null;
    ReturnReceipt returnReceipt = null;

    if (type == null || requestIdParam == null) {
        invalid = true;
    } else {
        try {
            int requestId = Integer.parseInt(requestIdParam);
            ReceiptDAO receiptDAO = new ReceiptDAO();
            if ("issue".equals(type)) {
                BookRequestDAO requestDAO = new BookRequestDAO();
                bookRequest = requestDAO.getRequestById(requestId);
                if (bookRequest == null || !student.getUsn().equals(bookRequest.getUsn())) {
                    invalid = true;
                } else {
                    issueReceipt = receiptDAO.getIssueReceiptByRequestId(requestId);
                }
            } else if ("return".equals(type)) {
                ReturnRequestDAO requestDAO = new ReturnRequestDAO();
                returnRequest = requestDAO.getRequestById(requestId);
                if (returnRequest == null || !student.getUsn().equals(returnRequest.getUsn())) {
                    invalid = true;
                } else {
                    returnReceipt = receiptDAO.getReturnReceiptByRequestId(requestId);
                }
            } else {
                invalid = true;
            }
        } catch (NumberFormatException e) {
            invalid = true;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Receipt — Library Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        /* Receipt-specific styles */
        .receipt-card { border:1px solid #e0e0e0; padding:18px; border-radius:6px; max-width:820px; margin:0 auto; background:#fff }
        .receipt-header { text-align:center; margin-bottom:12px }
        .receipt-header h2 { margin:0; font-size:20px; letter-spacing:1px }
        .receipt-header .sub { color:#666; font-size:13px }
        .receipt-grid { display:grid; grid-template-columns:160px 1fr; gap:10px 18px; align-items:start }
        .receipt-grid div { padding:2px 0 }
    </style>
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
            <a href="searchBook.jsp" class="nav-link"><span class="nav-icon">🔍</span> Search Books</a>
            <div class="nav-section-title">Transactions</div>
            <a href="studentDashboard.jsp" class="nav-link"><span class="nav-icon">📚</span> Book History</a>
            <div class="nav-section-title">Account</div>
            <a href="profile.jsp" class="nav-link"><span class="nav-icon">👤</span> My Profile</a>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="nav-link"><span class="nav-icon">🚪</span> Logout</a>
        </nav>
    </aside>
    <div class="main-content">
        <div class="topbar">
            <div class="topbar-title">🧾 Receipt</div>
            <div class="topbar-actions"><span class="badge badge-success">Student</span></div>
        </div>
        <div class="page-content">
            <div class="receipt-header">
                <h2>SDM CET DHARWAD</h2>
                <div class="sub">Library Management System — Student Receipt</div>
                <hr style="margin-top:12px; margin-bottom:14px; border:none; border-top:1px solid #ddd;">
            </div>
            <% if (invalid) { %>
                <div class="alert alert-danger">Invalid receipt request or access denied.</div>
            <% } else if ("issue".equals(type)) { %>
                <div class="receipt-card">
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px;">
                        <div style="font-weight:600">📘 Issue Receipt</div>
                        <div><button onclick="window.print()" class="btn btn-outline">Print</button></div>
                    </div>
                    <% if (issueReceipt == null) { %>
                        <p class="text-muted">Issue receipt has not been generated yet. Please check again later.</p>
                    <% } else { %>
                        <div class="receipt-grid">
                            <div><strong>Receipt #</strong></div><div><%= issueReceipt.getReceiptNumber() %></div>
                            <div><strong>Student Name</strong></div><div><%= student.getStudentName() %></div>
                            <div><strong>Student ID</strong></div><div><%= student.getUsn() %></div>
                            <div><strong>Book Title</strong></div><div><%= bookRequest.getBookName() %></div>
                            <div><strong>Author</strong></div><div><%= bookRequest.getAuthorName() %></div>
                            <div><strong>Issue Date</strong></div><div><%= issueReceipt.getGeneratedDate() %></div>
                            <div><strong>Due Return Date</strong></div><div><%= issueReceipt.getDueDate() %></div>
                            <div><strong>Approval Status</strong></div><div><%= issueReceipt.getApprovalStatus() %></div>
                            <div><strong>Librarian Notes</strong></div><div><%= bookRequest.getLibrarianComment() != null ? bookRequest.getLibrarianComment() : "—" %></div>
                        </div>
                    <% } %>
                </div>
            <% } else if ("return".equals(type)) { %>
                <div class="receipt-card">
                    <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:12px;">
                        <div style="font-weight:600">↩️ Return Receipt</div>
                        <div><button onclick="window.print()" class="btn btn-outline">Print</button></div>
                    </div>
                    <% if (returnReceipt == null) { %>
                        <p class="text-muted">Return receipt has not been generated yet. Please check again later.</p>
                    <% } else { %>
                        <div class="receipt-grid">
                            <div><strong>Receipt #</strong></div><div><%= returnReceipt.getReceiptNumber() %></div>
                            <div><strong>Student Name</strong></div><div><%= student.getStudentName() %></div>
                            <div><strong>Student ID</strong></div><div><%= student.getUsn() %></div>
                            <div><strong>Book Title</strong></div><div><%= returnRequest.getBookName() %></div>
                            <div><strong>Return Date</strong></div><div><%= returnReceipt.getGeneratedDate() %></div>
                            <div><strong>Fine Amount</strong></div><div>₹<%= String.format("%.2f", returnReceipt.getFineAmount()) %></div>
                            <div><strong>Return Status</strong></div><div><%= returnReceipt.getReturnStatus() %></div>
                            <div><strong>Librarian Notes</strong></div><div><%= returnRequest.getLibrarianComment() != null ? returnRequest.getLibrarianComment() : "—" %></div>
                        </div>
                    <% } %>
                </div>
            <% } %>
            <div style="margin-top:20px;">
                <a href="studentDashboard.jsp" class="btn btn-outline">Back to Dashboard</a>
            </div>
        </div>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
