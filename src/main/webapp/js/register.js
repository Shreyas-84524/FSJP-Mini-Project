/**
 * Job Portal System - Registration Client Logic
 * Phase 3: Registration & UI Integration
 */

document.addEventListener('DOMContentLoaded', function () {
    const form = document.getElementById('registrationForm');
    const roleJobSeeker = document.getElementById('roleJobSeeker');
    const roleRecruiter = document.getElementById('roleRecruiter');
    const jobSeekerSection = document.getElementById('jobSeekerSection');
    const recruiterSection = document.getElementById('recruiterSection');
    const companyNameInput = document.getElementById('companyName');
    const clientErrorBanner = document.getElementById('clientErrorBanner');

    const emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$/;

    // -------------------------------------------------------
    // 1. Role-based Field Toggle
    // -------------------------------------------------------
    function updateRoleVisibility() {
        const isRecruiter = roleRecruiter && roleRecruiter.checked;

        const jsCard = document.getElementById('roleCardJobSeeker');
        const recCard = document.getElementById('roleCardRecruiter');

        if (isRecruiter) {
            // Show Recruiter fields
            if (recruiterSection) recruiterSection.classList.remove('hidden-section');
            if (jobSeekerSection) jobSeekerSection.classList.add('hidden-section');

            // Toggle card active states
            if (recCard) recCard.classList.add('selected');
            if (jsCard) jsCard.classList.remove('selected');

            // Enable recruiter inputs, disable job seeker inputs
            toggleInputs(recruiterSection, true);
            toggleInputs(jobSeekerSection, false);

            if (companyNameInput) {
                companyNameInput.setAttribute('required', 'required');
            }
        } else {
            // Show Job Seeker fields
            if (jobSeekerSection) jobSeekerSection.classList.remove('hidden-section');
            if (recruiterSection) recruiterSection.classList.add('hidden-section');

            // Toggle card active states
            if (jsCard) jsCard.classList.add('selected');
            if (recCard) recCard.classList.remove('selected');

            // Enable job seeker inputs, disable recruiter inputs
            toggleInputs(jobSeekerSection, true);
            toggleInputs(recruiterSection, false);

            if (companyNameInput) {
                companyNameInput.removeAttribute('required');
            }
        }
    }

    function toggleInputs(section, isEnabled) {
        if (!section) return;
        const inputs = section.querySelectorAll('input, select, textarea');
        inputs.forEach(function (input) {
            input.disabled = !isEnabled;
        });
    }

    // Attach role change listeners
    if (roleJobSeeker) {
        roleJobSeeker.addEventListener('change', updateRoleVisibility);
    }
    if (roleRecruiter) {
        roleRecruiter.addEventListener('change', updateRoleVisibility);
    }

    // Initial trigger
    updateRoleVisibility();

    // -------------------------------------------------------
    // 2. Client-Side Validation
    // -------------------------------------------------------
    if (form) {
        form.addEventListener('submit', function (event) {
            clearErrors();

            let isValid = true;
            let firstInvalidField = null;

            const nameInput = document.getElementById('name');
            const emailInput = document.getElementById('email');
            const passwordInput = document.getElementById('password');

            const nameVal = nameInput ? nameInput.value.trim() : '';
            const emailVal = emailInput ? emailInput.value.trim() : '';
            const passwordVal = passwordInput ? passwordInput.value : '';

            const isRecruiter = roleRecruiter && roleRecruiter.checked;

            // 1. Name validation
            if (!nameVal) {
                showFieldError('name', 'Full Name is required.');
                isValid = false;
                if (!firstInvalidField) firstInvalidField = nameInput;
            } else if (nameVal.length > 100) {
                showFieldError('name', 'Full Name must not exceed 100 characters.');
                isValid = false;
                if (!firstInvalidField) firstInvalidField = nameInput;
            }

            // 2. Email validation
            if (!emailVal) {
                showFieldError('email', 'Email address is required.');
                isValid = false;
                if (!firstInvalidField) firstInvalidField = emailInput;
            } else if (emailVal.length > 150) {
                showFieldError('email', 'Email address must not exceed 150 characters.');
                isValid = false;
                if (!firstInvalidField) firstInvalidField = emailInput;
            } else if (!emailRegex.test(emailVal)) {
                showFieldError('email', 'Please enter a valid email address.');
                isValid = false;
                if (!firstInvalidField) firstInvalidField = emailInput;
            }

            // 3. Password validation
            if (!passwordVal) {
                showFieldError('password', 'Password is required.');
                isValid = false;
                if (!firstInvalidField) firstInvalidField = passwordInput;
            } else if (passwordVal.length < 6) {
                showFieldError('password', 'Password must be at least 6 characters long.');
                isValid = false;
                if (!firstInvalidField) firstInvalidField = passwordInput;
            }

            // 4. Role-specific validation
            if (isRecruiter) {
                const compVal = companyNameInput ? companyNameInput.value.trim() : '';
                if (!compVal) {
                    showFieldError('companyName', 'Company Name is required for recruiter accounts.');
                    isValid = false;
                    if (!firstInvalidField) firstInvalidField = companyNameInput;
                } else if (compVal.length > 150) {
                    showFieldError('companyName', 'Company Name must not exceed 150 characters.');
                    isValid = false;
                    if (!firstInvalidField) firstInvalidField = companyNameInput;
                }
            }

            // If validation failed, prevent submit and show banner
            if (!isValid) {
                event.preventDefault();
                if (clientErrorBanner) {
                    clientErrorBanner.textContent = 'Please correct the highlighted errors before submitting.';
                    clientErrorBanner.style.display = 'block';
                }
                if (firstInvalidField) {
                    firstInvalidField.focus();
                }
            }
        });
    }

    // -------------------------------------------------------
    // Helper Functions
    // -------------------------------------------------------
    function showFieldError(fieldId, message) {
        const field = document.getElementById(fieldId);
        const errorEl = document.getElementById(fieldId + 'Error');
        if (field) {
            field.classList.add('is-invalid');
        }
        if (errorEl) {
            errorEl.textContent = message;
        }
    }

    function clearErrors() {
        const errorSpans = document.querySelectorAll('.field-error');
        errorSpans.forEach(function (el) {
            el.textContent = '';
        });

        const invalidInputs = document.querySelectorAll('.is-invalid');
        invalidInputs.forEach(function (el) {
            el.classList.remove('is-invalid');
        });

        if (clientErrorBanner) {
            clientErrorBanner.style.display = 'none';
            clientErrorBanner.textContent = '';
        }
    }

    // Clear individual field error on user input
    const allInputs = document.querySelectorAll('.form-control');
    allInputs.forEach(function (input) {
        input.addEventListener('input', function () {
            this.classList.remove('is-invalid');
            const errorEl = document.getElementById(this.id + 'Error');
            if (errorEl) {
                errorEl.textContent = '';
            }
        });
    });
});
