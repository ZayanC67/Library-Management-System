<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Login to Student Portal — Library Management System.">
    <title>Student Portal — Library Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<div class="login-page">
    <div class="login-container">

        <!-- Header -->
        <div class="login-header">
            <div class="login-logo" style="color: white; font-weight: bold;">🎓</div>
            <h1>Student Portal</h1>
            <p>Access your loans, search catalog, and clear dues</p>
        </div>

        <!-- Flash Messages -->
        <%
            String successMsg = (String) session.getAttribute("success");
            String errorMsg   = request.getAttribute("error") != null
                                ? (String) request.getAttribute("error")
                                : (String) session.getAttribute("error");
            if (successMsg != null) session.removeAttribute("success");
            if (session.getAttribute("error") != null) session.removeAttribute("error");
        %>
        <% if (successMsg != null) { %>
            <div class="alert alert-success" data-auto-dismiss>✅ <%= successMsg %></div>
        <% } %>
        <% if (errorMsg != null) { %>
            <div class="alert alert-danger" data-auto-dismiss>❌ <%= errorMsg %></div>
        <% } %>
        <% if ("true".equals(request.getParameter("logout"))) { %>
            <div class="alert alert-info" data-auto-dismiss>👋 You have been logged out successfully.</div>
        <% } %>

        <!-- Login Card -->
        <div class="login-card">

            <!-- Sub-Tabs: Sign In and Register -->
            <div class="role-tabs">
                <button class="role-tab active" id="tab-login" onclick="switchAuthMode('login')">🔑 Sign In</button>
                <button class="role-tab" id="tab-register" onclick="switchAuthMode('register')">✍️ Register</button>
            </div>

            <!-- ── STUDENT LOGIN FORM ── -->
            <div id="form-login" class="role-form">
                <form action="LoginServlet" method="post" onsubmit="return validateStudentLogin()">
                    <input type="hidden" name="role" value="student">
                    <div class="form-group">
                        <label class="form-label" for="studentUsn">University Seat Number (USN)</label>
                        <input type="text" id="studentUsn" name="username"
                               class="form-control" placeholder="e.g. 1RN21CS001"
                               value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="studentPassword">Password</label>
                        <input type="password" id="studentPassword" name="password"
                               class="form-control" placeholder="Enter your password" required>
                    </div>
                    <button type="submit" class="btn btn-primary w-100" style="justify-content:center;">
                        🔑 Login as Student
                    </button>
                </form>
                <p class="text-center text-muted mt-2" style="font-size:13px;">
                    Don't have an account? <a href="javascript:void(0)" onclick="switchAuthMode('register')" style="font-weight: 600; color: var(--primary-light);">Register here</a>
                </p>
            </div>

            <!-- ── STUDENT REGISTRATION FORM ── -->
            <div id="form-register" class="role-form hidden">
                <form action="StudentServlet" method="post" onsubmit="return validateRegistration()">
                    <input type="hidden" name="action" value="register">
                    <div class="form-group">
                        <label class="form-label" for="regUsn">USN *</label>
                        <input type="text" id="regUsn" name="usn" class="form-control" placeholder="e.g. 1RN21CS001" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="regName">Full Name *</label>
                        <input type="text" id="regName" name="studentName" class="form-control" placeholder="Your full name" required>
                    </div>
                    <div class="form-grid">
                        <div class="form-group">
                            <label class="form-label" for="regSemester">Semester *</label>
                            <input type="number" id="regSemester" name="semester" min="1" max="8"
                                   class="form-control" placeholder="1-8" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label" for="regBranch">Branch *</label>
                            <select id="regBranch" name="branch" class="form-control" required>
                                <option value="">Select Branch</option>
                                <option value="CSE">CSE</option>
                                <option value="ISE">ISE</option>
                                <option value="ECE">ECE</option>
                                <option value="EEE">EEE</option>
                                <option value="ME">ME</option>
                                <option value="CV">Civil</option>
                                <option value="AI/ML">AI/ML</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="regPhone">Phone Number *</label>
                        <input type="tel" id="regPhone" name="phoneNo" class="form-control" placeholder="10-digit mobile number" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label" for="regPassword">Password *</label>
                        <input type="password" id="regPassword" name="password" class="form-control" placeholder="Create a password" required>
                    </div>
                    <button type="submit" class="btn btn-success w-100" style="justify-content:center;">
                        ✅ Register Account
                    </button>
                </form>
                <p class="text-center text-muted mt-2" style="font-size:13px;">
                    Already registered? <a href="javascript:void(0)" onclick="switchAuthMode('login')" style="font-weight: 600; color: var(--primary-light);">Back to Login</a>
                </p>
            </div>

        </div><!-- end login-card -->

        <p class="text-center text-muted mt-2" style="font-size:12px;">
            <a href="index.jsp">← Back to Home</a>
        </p>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/script.js"></script>
<script>
    function switchAuthMode(mode) {
        const loginForm = document.getElementById('form-login');
        const registerForm = document.getElementById('form-register');
        const loginTab = document.getElementById('tab-login');
        const registerTab = document.getElementById('tab-register');

        if (mode === 'login') {
            loginForm.classList.remove('hidden');
            registerForm.classList.add('hidden');
            loginTab.classList.add('active');
            registerTab.classList.remove('active');
        } else {
            loginForm.classList.add('hidden');
            registerForm.classList.remove('hidden');
            loginTab.classList.remove('active');
            registerTab.classList.add('active');
        }
        clearErrors();
    }

    // Load sub-tab from query parameters if active
    window.addEventListener('DOMContentLoaded', () => {
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('tab') === 'register') {
            switchAuthMode('register');
        }
    });
</script>
</body>
</html>
