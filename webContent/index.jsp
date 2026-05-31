<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Library Management System — Manage books, students, and transactions efficiently.">
    <title>Library Management System</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
<style>
  .tab-section { display: none; }
  .tab-section.active { display: block; animation: fadeInUp 0.4s cubic-bezier(0.16,1,0.3,1) forwards; }
</style>
</head>
<body>
<div class="landing">

    <!-- ── Navigation ── -->
    <nav class="landing-nav">
        <div class="landing-logo">
            <div class="icon" style="color: white; font-weight: bold;">📚</div>
            <span class="name">LibraryMS</span>
        </div>
        <div class="landing-nav-links">
            <span onclick="switchTab('home')" id="nav-home" class="landing-nav-link active">Home</span>
            <span onclick="switchTab('about')" id="nav-about" class="landing-nav-link">About Us</span>
            <span onclick="switchTab('features')" id="nav-features" class="landing-nav-link">Features</span>
            <span onclick="switchTab('auth')" id="nav-auth" class="landing-nav-link">Login / Register</span>
        </div>
    </nav>

    <!-- Flash Messages (in case of redirections) -->
    <div style="max-width: 500px; margin: 20px auto 0; padding: 0 20px;">
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
    </div>

    <!-- ═══════════════════════════════
         SECTION 1: HOME TAB
         ═══════════════════════════════ -->
    <section id="section-home" class="tab-section active">
        <!-- Hero Section -->
        <div class="landing-hero" style="padding-top: 60px;">
            <h1 style="color: var(--text-primary); background: none; -webkit-text-fill-color: initial; font-size: 54px;">
                Smart Library<br><span style="color: var(--primary);">Management System</span>
            </h1>
            <p>A modern, efficient platform for managing books, students, and library transactions &mdash; built for college administrators and students.</p>
            <div class="hero-buttons">
                <button onclick="switchTab('auth', 'login')" class="hero-btn hero-btn-primary">
                    🎓 Student Login
                </button>
                <button onclick="switchTab('features')" class="hero-btn hero-btn-outline">
                    🔍 Explore Features
                </button>
            </div>
        </div>

        <!-- Info / Stats Grid -->
        <div class="feature-cards" style="padding-top: 0; padding-bottom: 60px; max-width: 1000px;">
            <div class="feature-card" style="text-align: center;">
                <div class="fc-icon">📚</div>
                <h3>Rich Book Catalog</h3>
                <p>Browse through an expansive collection of literature, computer science journals, and academic guides instantly.</p>
            </div>
            <div class="feature-card" style="text-align: center;">
                <div class="fc-icon">⚡</div>
                <h3>Instant Transactions</h3>
                <p>Digital checking of book borrowing and returns. Eliminate the paperwork and manual logs entirely.</p>
            </div>
            <div class="feature-card" style="text-align: center;">
                <div class="fc-icon">💸</div>
                <h3>Fine Settlement</h3>
                <p>Real-time fine computation based on overdues. Clear any dues in a secure online student environment.</p>
            </div>
        </div>
    </section>

    <!-- ═══════════════════════════════
         SECTION 2: FEATURES TAB
         ═══════════════════════════════ -->
    <section id="section-features" class="tab-section">
        <div class="features-section">
            <div class="section-header">
                <h2>Platform Features</h2>
                <p>Discover the powerful capabilities built to provide a seamless library ecosystem.</p>
            </div>
            
            <div class="feature-cards feature-grid-custom" style="padding: 0; margin-bottom: 40px;">
                <div class="feature-card feat-grad-1">
                    <div class="fc-icon">🔍</div>
                    <h3>Smart Book Search</h3>
                    <p>Search books by name, author, or ID. Check real-time availability and location status instantly.</p>
                </div>
                <div class="feature-card feat-grad-2">
                    <div class="fc-icon">🔄</div>
                    <h3>Self-service Borrowing/Returns</h3>
                    <p>Students can borrow and return books with a single click. Double issue prevention built-in.</p>
                </div>
                <div class="feature-card feat-grad-3">
                    <div class="fc-icon">💰</div>
                    <h3>Automatic Fine Calculations</h3>
                    <p>Automatic fine computation for overdue books. Payment records stored securely in database logs.</p>
                </div>
                <div class="feature-card feat-grad-4">
                    <div class="fc-icon">📊</div>
                    <h3>Administrative Analytics</h3>
                    <p>Librarians get a live cockpit with inventory totals, checkout rates, active students, and income records.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- ═══════════════════════════════
         SECTION 3: ABOUT US TAB
         ═══════════════════════════════ -->
    <section id="section-about" class="tab-section">
        <div class="about-section">
            <div class="section-header">
                <h2>Meet the Developers</h2>
                <p>The talented engineering group behind the Library Management System.</p>
            </div>

            <div class="profile-grid">
                <!-- Profile 1: MD AREEB KITTUR -->
                <div class="profile-card">
                    <div class="profile-avatar" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); background-size: cover; background-position: center;">
                        <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=areeb&scale=80" alt="MD AREEB KITTUR" style="width:100%; height:100%; border-radius:50%; object-fit:cover;">
                    </div>
                    <h3 class="profile-name">MD AREEB KITTUR</h3>
                    <span class="profile-role-badge">Lead Backend Developer &amp; Java Architect</span>
                    <p class="profile-desc">Engineered high-performance Java Servlets, structured SQL integration layers, and optimized back-end transaction controllers.</p>
                    <div class="profile-skills">
                        <span class="skill-tag">Servlets</span>
                        <span class="skill-tag">JDBC</span>
                        <span class="skill-tag">Core Java</span>
                        <span class="skill-tag">Tomcat</span>
                    </div>
                </div>

                <!-- Profile 2: SHAHID AHMED AKKI -->
                <div class="profile-card">
                    <div class="profile-avatar" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); background-size: cover; background-position: center;">
                        <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=shahid&scale=80" alt="SHAHID AHMED AKKI" style="width:100%; height:100%; border-radius:50%; object-fit:cover;">
                    </div>
                    <h3 class="profile-name">SHAHID AHMED AKKI</h3>
                    <span class="profile-role-badge">Database Designer &amp; SQL Specialist</span>
                    <p class="profile-desc">Designed MySQL schemas, enforced complex relational constraints, tuned queries, and managed transactional stability.</p>
                    <div class="profile-skills">
                        <span class="skill-tag">MySQL</span>
                        <span class="skill-tag">Database Tuning</span>
                        <span class="skill-tag">Relational DB</span>
                        <span class="skill-tag">SQL Logic</span>
                    </div>
                </div>

                <!-- Profile 3: ZAYAN C -->
                <div class="profile-card">
                    <div class="profile-avatar" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); background-size: cover; background-position: center;">
                        <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=zayan&scale=80" alt="ZAYAN C" style="width:100%; height:100%; border-radius:50%; object-fit:cover;">
                    </div>
                    <h3 class="profile-name">ZAYAN C</h3>
                    <span class="profile-role-badge">Lead Full-Stack Developer &amp; DevOps Coordinator</span>
                    <p class="profile-desc">Coordinated MVC components, refined integration pathways, handled deployment engineering, and overseen project timelines.</p>
                    <div class="profile-skills">
                        <span class="skill-tag">Project Lead</span>
                        <span class="skill-tag">Full-Stack</span>
                        <span class="skill-tag">DevOps</span>
                        <span class="skill-tag">System Design</span>
                    </div>
                </div>

                <!-- Profile 4: UJWAL SHET -->
                <div class="profile-card">
                    <div class="profile-avatar" style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); background-size: cover; background-position: center;">
                        <img src="https://api.dicebear.com/7.x/avataaars/svg?seed=ujwal&scale=80" alt="UJWAL SHET" style="width:100%; height:100%; border-radius:50%; object-fit:cover;">
                    </div>
                    <h3 class="profile-name">UJWAL SHET</h3>
                    <span class="profile-role-badge">Lead UI/UX Designer &amp; Frontend Engineer</span>
                    <p class="profile-desc">Crafted high-fidelity interfaces, animated component transitions, established CSS design tokens, and designed the dark glassmorphism aesthetic.</p>
                    <div class="profile-skills">
                        <span class="skill-tag">UI/UX Layout</span>
                        <span class="skill-tag">CSS Gradients</span>
                        <span class="skill-tag">Dynamic JS</span>
                        <span class="skill-tag">Typography</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- ═══════════════════════════════
         SECTION 4: STUDENT LOGIN & REGISTRATION
         ═══════════════════════════════ -->
    <section id="section-auth" class="tab-section">
        <div style="max-width: 480px; margin: 40px auto 80px; padding: 0 20px;">
            <div class="login-header">
                <div class="login-logo" style="color: white; font-weight: bold;">🎓</div>
                <h1>Student Portal</h1>
                <p>Access your personal dashboard, search books, and check borrow logs</p>
            </div>

            <div class="login-card">
                <!-- Role/Mode Toggle -->
                <div class="role-tabs">
                    <button class="role-tab active" id="btn-login-mode" onclick="toggleAuthMode('login')">🔑 Sign In</button>
                    <button class="role-tab" id="btn-register-mode" onclick="toggleAuthMode('register')">✍️ Register</button>
                </div>

                <!-- ── STUDENT LOGIN FORM ── -->
                <div id="auth-login-view" class="role-form">
                    <form action="LoginServlet" method="post" onsubmit="return validateStudentLogin()">
                        <input type="hidden" name="role" value="student">
                        <div class="form-group">
                            <label class="form-label" for="studentUsn">University Seat Number (USN)</label>
                            <input type="text" id="studentUsn" name="username"
                                   class="form-control" placeholder="e.g. 1RN21CS001" required>
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
                        Don't have an account? <a href="javascript:void(0)" onclick="toggleAuthMode('register')" style="font-weight: 600; color: var(--primary-light);">Register here</a>
                    </p>
                </div>

                <!-- ── STUDENT REGISTRATION FORM ── -->
                <div id="auth-register-view" class="role-form hidden">
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
                        Already registered? <a href="javascript:void(0)" onclick="toggleAuthMode('login')" style="font-weight: 600; color: var(--primary-light);">Sign in here</a>
                    </p>
                </div>
            </div>
        </div>
    </section>

    <!-- ── Footer ── -->
    <footer style="text-align:center;padding:24px;border-top:1px solid var(--border);color:var(--text-muted);font-size:13px; background: rgba(255,255,255,0.02);">
        &copy; 2026 Library Management System &mdash; Built with Java EE + JSP + JDBC
    </footer>
</div>

<script src="${pageContext.request.contextPath}/js/script.js"></script>
<script>
    // Tab switching engine
    function switchTab(tabId, submode) {
        // Toggle tab sections
        document.querySelectorAll('.tab-section').forEach(section => {
            section.classList.remove('active');
        });
        const activeSection = document.getElementById('section-' + tabId);
        if (activeSection) {
            activeSection.classList.add('active');
        }

        // Toggle navigation link highlights
        document.querySelectorAll('.landing-nav-link').forEach(link => {
            link.classList.remove('active');
        });
        const activeLink = document.getElementById('nav-' + tabId);
        if (activeLink) {
            activeLink.classList.add('active');
        }

        // Scroll to top
        window.scrollTo({ top: 0, behavior: 'smooth' });

        // Handle inner student modes
        if (tabId === 'auth' && submode) {
            toggleAuthMode(submode);
        }
    }

    // Toggle inside Student Portal between Login and Register
    function toggleAuthMode(mode) {
        const loginView = document.getElementById('auth-login-view');
        const registerView = document.getElementById('auth-register-view');
        const loginBtn = document.getElementById('btn-login-mode');
        const registerBtn = document.getElementById('btn-register-mode');

        if (mode === 'login') {
            loginView.classList.remove('hidden');
            registerView.classList.add('hidden');
            loginBtn.classList.add('active');
            registerBtn.classList.remove('active');
        } else {
            loginView.classList.add('hidden');
            registerView.classList.remove('hidden');
            loginBtn.classList.remove('active');
            registerBtn.classList.add('active');
        }
    }

    // Auto load specific tab from query params if specified
    window.addEventListener('DOMContentLoaded', () => {
        const urlParams = new URLSearchParams(window.location.search);
        const tabParam = urlParams.get('tab');
        if (tabParam === 'register') {
            switchTab('auth', 'register');
        } else if (tabParam === 'login' || tabParam === 'auth') {
            switchTab('auth', 'login');
        } else if (tabParam === 'features') {
            switchTab('features');
        } else if (tabParam === 'about') {
            switchTab('about');
        }
    });
</script>
</body>
</html>
