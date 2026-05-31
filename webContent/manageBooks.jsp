<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Librarian, model.Book, dao.BookDAO, java.util.List" %>
<%
    Librarian librarian = (Librarian) session.getAttribute("librarian");
    if (librarian == null) {
        response.sendRedirect(request.getContextPath() + "/librarianLogin.jsp");
        return;
    }
    BookDAO bookDAO = new BookDAO();
    String keyword = "";
    
    // First check if keyword is in REQUEST ATTRIBUTE (from SearchBookServlet forward)
    if (request.getAttribute("keyword") != null) {
        keyword = (String) request.getAttribute("keyword");
    } 
    // Otherwise check URL parameter
    else if (request.getParameter("keyword") != null) {
        keyword = request.getParameter("keyword");
    }
    
    List<Book> books;
    if (request.getAttribute("bookList") != null) {
        books = (List<Book>) request.getAttribute("bookList");
    } else if (!keyword.isEmpty()) {
        books = bookDAO.searchBooks(keyword);
    } else {
        books = bookDAO.getAllBooks();
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
    <title>Manage Books — Library Management System</title>
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
            <a href="${pageContext.request.contextPath}/librarian/manageBooks.jsp" class="nav-link active"><span class="nav-icon">📚</span> Manage Books</a>
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
            <div class="topbar-title">📚 Manage Books</div>
            <div class="topbar-actions">
                <span class="badge badge-info">Librarian</span>
                <a href="${pageContext.request.contextPath}/librarian/addBook.jsp" class="btn btn-primary btn-sm">➕ Add Book</a>
            </div>
        </div>
        <div class="page-content">
            <% if (successMsg != null) { %><div class="alert alert-success" data-auto-dismiss>✅ <%= successMsg %></div><% } %>
            <% if (errorMsg   != null) { %><div class="alert alert-danger"  data-auto-dismiss>❌ <%= errorMsg %></div><% } %>

            <!-- Search -->
            <div class="card mb-3">
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/SearchBookServlet" method="get" class="search-form">
                        <input type="text" name="keyword" class="search-input"
                               placeholder="Search by Book Name, Author, or Book ID..."
                               value="<%= keyword %>">
                        <button type="submit" class="btn btn-primary">🔍 Search</button>
                        <a href="${pageContext.request.contextPath}/librarian/manageBooks.jsp" class="btn btn-outline">Reset</a>
                    </form>
                    <input type="text" id="liveFilter" class="search-input" style="margin-top:8px;"
                           placeholder="Filter table instantly..."
                           onkeyup="filterTable('liveFilter','booksTable')">
                </div>
            </div>

            <!-- Books Table -->
            <div class="card">
                <div class="card-header">
                    <span class="card-title">📚 All Books (<%= books.size() %>)</span>
                </div>
                <div class="card-body">
                    <% if (books.isEmpty()) { %>
                        <p class="text-muted text-center" style="padding:30px;">No books found.</p>
                    <% } else { %>
                    <div class="table-wrapper">
                    <table id="booksTable">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Book ID</th>
                                <th>Book Name</th>
                                <th>Author</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% int i = 1; for (Book b : books) {
                               boolean avail = "Available".equals(b.getAvailabilityStatus()); %>
                            <tr>
                                <td><%= i++ %></td>
                                <td><span class="badge badge-primary">#<%= b.getBookId() %></span></td>
                                <td style="font-weight:600;max-width:200px;"><%= b.getBookName() %></td>
                                <td style="color:var(--text-secondary);"><%= b.getAuthorName() %></td>
                                <td>
                                    <span class="badge <%= avail ? "badge-success" : "badge-danger" %>">
                                        <%= avail ? "✅ Available" : "❌ Issued" %>
                                    </span>
                                </td>
                                <td style="display:flex;gap:6px;flex-wrap:wrap;">
                                    <!-- Delete Button -->
                                    <a href="${pageContext.request.contextPath}/RemoveBookServlet?bookId=<%= b.getBookId() %>"
                                       class="btn btn-danger btn-sm"
                                       onclick="return confirmDelete('Delete Book ID #<%= b.getBookId() %>?')">
                                        🗑️ Delete
                                    </a>
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
