<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Student, model.Book, dao.BookDAO, dao.BookRequestDAO, java.util.List, java.util.HashSet, java.util.Set, java.net.URLEncoder" %>
<%
    Student student = (Student) session.getAttribute("student");
    if (student == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    BookDAO bookDAO  = new BookDAO();
    BookRequestDAO requestDAO = new BookRequestDAO();
    Set<Integer> requestedBookIds = new HashSet<>();
    java.util.List<model.BookRequest> myRequests = requestDAO.getRequestsByUsn(student.getUsn());
    for (model.BookRequest br : myRequests) {
        if ("Pending".equals(br.getStatus())) {
            requestedBookIds.add(br.getBookId());
        }
    }
    String keyword   = request.getAttribute("keyword") != null ? (String) request.getAttribute("keyword") : "";
    List<Book> books = null;
    if (request.getAttribute("bookList") != null) {
        books = (List<Book>) request.getAttribute("bookList");
    } else if (!keyword.isEmpty()) {
        books = bookDAO.searchBooks(keyword);
    } else {
        books = bookDAO.getAllBooks();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Books — Library Management System</title>
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
            <a href="${pageContext.request.contextPath}/student/studentDashboard.jsp" class="nav-link"><span class="nav-icon">🏠</span> Dashboard</a>
            <a href="${pageContext.request.contextPath}/student/searchBook.jsp" class="nav-link active"><span class="nav-icon">🔍</span> Search Books</a>
            <div class="nav-section-title">Transactions</div>
            <a href="${pageContext.request.contextPath}/student/studentDashboard.jsp" class="nav-link"><span class="nav-icon">📚</span> Book History</a>
            <div class="nav-section-title">Account</div>
            <a href="${pageContext.request.contextPath}/student/profile.jsp" class="nav-link"><span class="nav-icon">👤</span> My Profile</a>
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
            <div class="topbar-title">🔍 Search Books</div>
            <div class="topbar-actions">
                <span class="badge badge-success">Student</span>
            </div>
        </div>
        <div class="page-content">
            <!-- Search Form -->
            <div class="card mb-3">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/SearchBookServlet" method="get" class="search-form">
                        <input type="text" name="keyword" class="search-input"
                               placeholder="Search by Book Name, Author, or Book ID..."
                               value="<%= keyword %>">
                        <button type="submit" class="btn btn-primary">🔍 Search</button>
                        <a href="${pageContext.request.contextPath}/student/searchBook.jsp" class="btn btn-outline">Reset</a>
                    </form>
                    <!-- Client-side filter -->
                    <input type="text" id="liveFilter" class="search-input" style="margin-top:8px;"
                           placeholder="Filter results instantly..." onkeyup="filterTable('liveFilter','bookTable')">
                </div>
            </div>

            <!-- Books Table -->
            <div class="card">
                <div class="card-header">
                    <span class="card-title">📚 Book Catalog (<%= books != null ? books.size() : 0 %> books)</span>
                </div>
                <div class="card-body">
                    <% if (books == null || books.isEmpty()) { %>
                        <p class="text-muted text-center" style="padding:30px;">
                            <%= !keyword.isEmpty() ? "No books found for \"" + keyword + "\"." : "No books in the library yet." %>
                        </p>
                    <% } else { %>
                    <div class="table-wrapper">
                    <table id="bookTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Book ID</th>
                                <th>Book Name</th>
                                <th>Author</th>
                                <th>Availability</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% int i = 1; for (Book b : books) {
                               boolean avail = "Available".equals(b.getAvailabilityStatus());
                               boolean requested = requestedBookIds.contains(b.getBookId()); %>
                            <tr>
                                <td><%= i++ %></td>
                                <td><span class="badge badge-primary">#<%= b.getBookId() %></span></td>
                                <td style="font-weight:600;"><%= b.getBookName() %></td>
                                <td style="color:var(--text-secondary);"><%= b.getAuthorName() %></td>
                                <td>
                                    <span class="badge <%= avail ? "badge-success" : "badge-danger" %>">
                                        <%= avail ? "✅ Available" : "❌ Issued" %>
                                    </span>
                                </td>
                                <td>
                                    <% if (avail) {
                                           if (requested) { %>
                                               <span class="badge badge-warning">Requested</span>
                                           <% } else { %>
                                               <form action="${pageContext.request.contextPath}/RequestBookServlet" method="post" style="margin:0;">
                                                   <input type="hidden" name="bookId" value="<%= b.getBookId() %>">
                                                   <input type="hidden" name="redirect" value="/student/searchBook.jsp?keyword=<%= URLEncoder.encode(keyword, "UTF-8") %>">
                                                   <button type="submit" class="btn btn-success btn-sm">📘 Request</button>
                                               </form>
                                           <% }
                                       } else { %>
                                           <span class="text-muted" style="font-size:12px;">Not Available</span>
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
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/script.js"></script>
</body>
</html>
