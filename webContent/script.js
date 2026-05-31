/**
 * Library Management System - JavaScript Utilities
 * Handles: Form validation, alerts, UI interactions, modals
 */

// ============================================================
// FORM VALIDATION
// ============================================================

/**
 * Validate Student Login Form
 */
function validateStudentLogin() {
    const usn      = document.getElementById('studentUsn');
    const password = document.getElementById('studentPassword');
    let valid = true;

    clearErrors();

    if (!usn.value.trim()) {
        showError(usn, 'USN is required.');
        valid = false;
    } else if (usn.value.trim().length < 5) {
        showError(usn, 'USN must be at least 5 characters.');
        valid = false;
    }

    if (!password.value.trim()) {
        showError(password, 'Password is required.');
        valid = false;
    } else if (password.value.trim().length < 4) {
        showError(password, 'Password must be at least 4 characters.');
        valid = false;
    }

    return valid;
}

/**
 * Validate Librarian Login Form
 */
function validateLibrarianLogin() {
    const username = document.getElementById('librarianUsername');
    const password = document.getElementById('librarianPassword');
    let valid = true;

    clearErrors();

    if (!username.value.trim()) {
        showError(username, 'Username is required.');
        valid = false;
    }

    if (!password.value.trim()) {
        showError(password, 'Password is required.');
        valid = false;
    }

    return valid;
}

/**
 * Validate Registration Form
 */
function validateRegistration() {
    const usn     = document.getElementById('regUsn');
    const name    = document.getElementById('regName');
    const sem     = document.getElementById('regSemester');
    const branch  = document.getElementById('regBranch');
    const phone   = document.getElementById('regPhone');
    const pass    = document.getElementById('regPassword');
    let valid = true;

    clearErrors();

    if (!usn.value.trim()) {
        showError(usn, 'USN is required.'); valid = false;
    }
    if (!name.value.trim()) {
        showError(name, 'Name is required.'); valid = false;
    }
    if (!sem.value || sem.value < 1 || sem.value > 8) {
        showError(sem, 'Semester must be between 1 and 8.'); valid = false;
    }
    if (!branch.value.trim()) {
        showError(branch, 'Branch is required.'); valid = false;
    }
    if (!phone.value.trim()) {
        showError(phone, 'Phone number is required.'); valid = false;
    } else if (!/^\d{10}$/.test(phone.value.trim())) {
        showError(phone, 'Phone must be exactly 10 digits.'); valid = false;
    }
    if (!pass.value.trim()) {
        showError(pass, 'Password is required.'); valid = false;
    } else if (pass.value.trim().length < 4) {
        showError(pass, 'Password must be at least 4 characters.'); valid = false;
    }

    return valid;
}

/**
 * Validate Add Book Form
 */
function validateAddBook() {
    const bookName   = document.getElementById('bookName');
    const authorName = document.getElementById('authorName');
    let valid = true;

    clearErrors();

    if (!bookName.value.trim()) {
        showError(bookName, 'Book name is required.'); valid = false;
    }
    if (!authorName.value.trim()) {
        showError(authorName, 'Author name is required.'); valid = false;
    }

    return valid;
}

/**
 * Validate Issue / Return Book Form
 */
function validateIssueReturn(bookIdId, usnId) {
    const bookId = document.getElementById(bookIdId);
    const usn    = document.getElementById(usnId);
    let valid    = true;

    clearErrors();

    if (!bookId.value.trim()) {
        showError(bookId, 'Book ID is required.'); valid = false;
    } else if (isNaN(bookId.value.trim())) {
        showError(bookId, 'Book ID must be a number.'); valid = false;
    }

    if (usn && !usn.value.trim()) {
        showError(usn, 'USN is required.'); valid = false;
    }

    return valid;
}

/**
 * Validate Payment Form
 */
function validatePayment() {
    const type   = document.getElementById('paymentType');
    const amount = document.getElementById('paymentAmount');
    let valid    = true;

    clearErrors();

    if (!type.value.trim()) {
        showError(type, 'Payment type is required.'); valid = false;
    }
    if (!amount.value.trim()) {
        showError(amount, 'Amount is required.'); valid = false;
    } else if (isNaN(amount.value) || parseFloat(amount.value) <= 0) {
        showError(amount, 'Amount must be a positive number.'); valid = false;
    }

    return valid;
}

// ============================================================
// HELPER: Show/Clear Validation Errors
// ============================================================

function showError(inputEl, message) {
    inputEl.style.borderColor = 'var(--danger)';
    let errEl = inputEl.nextElementSibling;
    if (!errEl || !errEl.classList.contains('form-error')) {
        errEl = document.createElement('span');
        errEl.className = 'form-error';
        inputEl.parentNode.insertBefore(errEl, inputEl.nextSibling);
    }
    errEl.textContent = message;
    errEl.classList.add('visible');
}

function clearErrors() {
    document.querySelectorAll('.form-control').forEach(el => {
        el.style.borderColor = '';
    });
    document.querySelectorAll('.form-error').forEach(el => {
        el.textContent = '';
        el.classList.remove('visible');
    });
}

// ============================================================
// ROLE TABS (Login Page)
// ============================================================

function switchRole(role) {
    document.querySelectorAll('.role-tab').forEach(t => t.classList.remove('active'));
    document.querySelectorAll('.role-form').forEach(f => f.classList.add('hidden'));

    document.getElementById('tab-' + role).classList.add('active');
    document.getElementById('form-' + role).classList.remove('hidden');
    document.getElementById('roleInput').value = role;

    clearErrors();
}

// ============================================================
// AUTO-DISMISS ALERTS
// ============================================================

document.addEventListener('DOMContentLoaded', function () {
    const alerts = document.querySelectorAll('.alert[data-auto-dismiss]');
    alerts.forEach(function (alert) {
        setTimeout(function () {
            alert.style.transition = 'opacity 0.5s ease';
            alert.style.opacity    = '0';
            setTimeout(function () { alert.remove(); }, 500);
        }, 4000);
    });

    // Handle URL tab param
    const params = new URLSearchParams(window.location.search);
    if (params.get('tab') === 'register') {
        const regTab = document.getElementById('tab-register');
        if (regTab) regTab.click();
    }
    if (params.get('role') === 'librarian') {
        const libTab = document.getElementById('tab-librarian');
        if (libTab) switchRole('librarian');
    }
});

// ============================================================
// MODAL CONTROL
// ============================================================

function openModal(id) {
    const overlay = document.getElementById(id);
    if (overlay) overlay.classList.add('active');
}

function closeModal(id) {
    const overlay = document.getElementById(id);
    if (overlay) overlay.classList.remove('active');
}

// Close modal on overlay click
document.addEventListener('click', function (e) {
    if (e.target.classList.contains('modal-overlay')) {
        e.target.classList.remove('active');
    }
});

// ============================================================
// CONFIRM DELETE
// ============================================================

function confirmDelete(message) {
    return confirm(message || 'Are you sure you want to delete this record? This action cannot be undone.');
}

// ============================================================
// POPULATE UPDATE MODAL
// ============================================================

function populateUpdateModal(bookId, bookName, authorName, status) {
    document.getElementById('updateBookId').value     = bookId;
    document.getElementById('updateBookName').value   = bookName;
    document.getElementById('updateAuthorName').value = authorName;
    const statusEl = document.getElementById('updateStatus');
    if (statusEl) statusEl.value = status;
    openModal('updateModal');
}

// ============================================================
// SEARCH FILTER (client-side table filter)
// ============================================================

function filterTable(inputId, tableId) {
    const filter = document.getElementById(inputId).value.toLowerCase();
    const rows   = document.querySelectorAll('#' + tableId + ' tbody tr');
    rows.forEach(function (row) {
        const text = row.textContent.toLowerCase();
        row.style.display = text.includes(filter) ? '' : 'none';
    });
}

// ============================================================
// SIDEBAR TOGGLE (mobile)
// ============================================================

function toggleSidebar() {
    const sidebar = document.querySelector('.sidebar');
    if (sidebar) sidebar.classList.toggle('open');
}
