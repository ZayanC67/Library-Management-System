<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Student, model.Payment, dao.PaymentDAO, java.util.List" %>
<%
    Student student = (Student) session.getAttribute("student");
    if (student == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    PaymentDAO payDAO = new PaymentDAO();
    List<Payment> payments = payDAO.getPaymentsByUsn(student.getUsn());
    double totalPaid = 0;
    for (Payment p : payments) totalPaid += p.getAmount();

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
    <title>My Payments — Library Management System</title>
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
            <div class="topbar-title">💰 My Payment Records</div>
            <div class="topbar-actions"><span class="badge badge-success">Student</span></div>
        </div>
        <div class="page-content">
            <% if (successMsg != null) { %><div class="alert alert-success" data-auto-dismiss>✅ <%= successMsg %></div><% } %>
            <% if (errorMsg   != null) { %><div class="alert alert-danger"  data-auto-dismiss>❌ <%= errorMsg %></div><% } %>

            <!-- Summary -->
            <div class="stats-grid" style="grid-template-columns:repeat(3,1fr);">
                <div class="stat-card">
                    <div class="stat-icon red">💰</div>
                    <div class="stat-info">
                        <div class="stat-label">Total Paid</div>
                        <div class="stat-value">₹<%= String.format("%.2f", totalPaid) %></div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon amber">📄</div>
                    <div class="stat-info">
                        <div class="stat-label">Transactions</div>
                        <div class="stat-value"><%= payments.size() %></div>
                    </div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon blue">👤</div>
                    <div class="stat-info">
                        <div class="stat-label">Your USN</div>
                        <div class="stat-value" style="font-size:16px;"><%= student.getUsn() %></div>
                    </div>
                </div>
            </div>

            <!-- Payment Records Table -->
            <div class="card">
                <div class="card-header">
                    <span class="card-title">📄 Payment History</span>
                </div>
                <div class="card-body">
                    <% if (payments.isEmpty()) { %>
                        <p class="text-muted text-center" style="padding:30px;">
                            No payment records found. Fines are auto-recorded when you return overdue books.
                        </p>
                    <% } else { %>
                    <div class="table-wrapper">
                    <table>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Payment ID</th>
                                <th>Type</th>
                                <th>Amount</th>
                                <th>Date</th>
                                <th>Method Details</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% int i = 1; for (Payment p : payments) { %>
                            <tr>
                                <td><%= i++ %></td>
                                <td><span class="badge badge-primary">#<%= p.getPaymentId() %></span></td>
                                <td>
                                    <span class="badge <%= "Fine".equals(p.getPaymentType()) ? "badge-danger" : "badge-info" %>">
                                        <%= p.getPaymentType() %>
                                    </span>
                                </td>
                                <td style="font-weight:700;color:var(--danger);">₹<%= String.format("%.2f", p.getAmount()) %></td>
                                <td><%= p.getPaymentDate() %></td>
                                <td style="color:var(--text-muted);font-size:12px;"><%= p.getPaymentDetails() %></td>
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
