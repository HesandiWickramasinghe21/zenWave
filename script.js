// --- 1. MODAL CONTROLS ---
function openModal() {
    const modal = document.getElementById('auth-modal');
    if (modal) {
        modal.classList.add('active');
        document.body.style.overflow = 'hidden'; 
    }
}

function closeModal() {
    const modal = document.getElementById('auth-modal');
    if (modal) {
        modal.classList.remove('active');
        document.body.style.overflow = 'auto'; 
    }
}

window.onclick = function(event) {
    const modal = document.getElementById('auth-modal');
    if (event.target == modal) {
        closeModal();
    }
};

// --- 3. UI TAB SWITCHING ---
function switchTab(mode) {
    const signupFields = document.querySelectorAll('.signup-only');
    const loginOnlyFields = document.querySelectorAll('.login-only');
    const submitBtn = document.getElementById('submit-btn');
    const signupTabBtn = document.getElementById('signup-tab');
    const loginTabBtn = document.getElementById('login-tab');

    if (mode === 'signup') {
        signupFields.forEach(el => el.style.display = 'block');
        loginOnlyFields.forEach(el => el.style.display = 'none');
        signupTabBtn.classList.add('active');
        loginTabBtn.classList.remove('active');
        submitBtn.textContent = 'Create Account';
    } else {
        signupFields.forEach(el => el.style.display = 'none');
        loginOnlyFields.forEach(el => el.style.display = 'block');
        loginTabBtn.classList.add('active');
        signupTabBtn.classList.remove('active');
        submitBtn.textContent = 'Log In';
    }
}

// --- 4. AUTHENTICATION (FIXED SYNTAX) ---
const authForm = document.getElementById('auth-form');

if (authForm) {
    authForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        const loginTab = document.getElementById('login-tab'); 
        const isLogin = loginTab && loginTab.classList.contains('active');
        const API_BASE_URL = 'http://127.0.0.1:8000';
        const endpoint = isLogin ? '/login' : '/signin'; 

        const email = document.getElementById('auth-email').value;
        const password = document.getElementById('auth-password').value;
        
        let payload = { email, password };
        
        if (!isLogin) {
            payload.full_name = document.getElementById('reg-name').value;
            payload.phone = document.getElementById('reg-phone').value;
            payload.birthday = document.getElementById('reg-dob').value;
            payload.gender = document.getElementById('reg-gender').value;
        }

        const submitBtn = document.getElementById('submit-btn');
        submitBtn.disabled = true;
        submitBtn.textContent = "Processing...";

        try {
            const response = await fetch(`${API_BASE_URL}${endpoint}`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(payload)
            });
            
            const data = await response.json();
            
            if (response.ok) {
                if (isLogin) {
                    localStorage.setItem('zen-token', data.access_token);
                    closeModal(); 
                    window.location.href = 'features.html'; 
                } else {
                    alert("Account created! Please log in.");
                    switchTab('login');
                }
            } else {
                alert(data.detail || "Authentication failed.");
            }
        } catch (error) {
            alert("Connection error. Is the backend server running?");
        } finally {
            submitBtn.disabled = false;
            submitBtn.textContent = isLogin ? "Log In" : "Create Account";
        }
    });
}

// --- 5. LOGOUT ---
function logoutUser() {
    localStorage.removeItem('zen-token');
    window.location.href = 'home.html';
}

// --- 6. PRICING TOGGLE ---
const billingToggle = document.getElementById('billing-toggle');
const premiumPriceText = document.getElementById('premium-price');

if (billingToggle && premiumPriceText) {
    billingToggle.addEventListener('change', () => {
        if (billingToggle.checked) {
            premiumPriceText.innerHTML = '$109.89<span>/yr</span>';
        } else {
            premiumPriceText.innerHTML = '$9.99<span>/mo</span>';
        }
    });
}

// --- 7. FEATURE ACCESS GATEKEEPER ---
function accessFeature(featureName, targetUrl) {
    const isPremium = localStorage.getItem('is-premium') === 'true';
    
    if (featureName === 'chatbot' || isPremium) {
        window.location.href = targetUrl;
        return;
    }

    let usage = JSON.parse(localStorage.getItem('usage-counts')) || { journal: 0, sound: 0, reports: 0 };
    
    if (usage[featureName] >= 3) {
        alert("Free limit reached! Upgrade to Premium.");
        window.location.href = '#pricing';
    } else {
        usage[featureName]++;
        localStorage.setItem('usage-counts', JSON.stringify(usage));
        window.location.href = targetUrl;
    }
}

// --- 8. REPORT TAB SWITCHING ---
document.addEventListener('DOMContentLoaded', () => {
    const tabs = document.querySelectorAll('.tab-item');
    
    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            const target = tab.getAttribute('data-tab');

            tabs.forEach(t => t.classList.remove('active'));
            tab.classList.add('active');

            document.querySelectorAll('.report-section').forEach(section => {
                section.classList.add('hidden');
            });
            
            const activeSection = document.getElementById(`${target}-content`);
            if (activeSection) {
                activeSection.classList.remove('hidden');
            }
        });
    });
});

document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') closeModal();
});

// === SCROLL PROGRESS BAR ===
window.addEventListener('scroll', () => {
    const scrollTop = document.documentElement.scrollTop;
    const scrollHeight = document.documentElement.scrollHeight - document.documentElement.clientHeight;
    const progress = (scrollTop / scrollHeight) * 100;
    document.getElementById('scroll-progress').style.width = progress + '%';
});

// === ACTIVE NAV LINK ON SCROLL ===
const sections = document.querySelectorAll('section[id], footer[id]');
const navLinks = document.querySelectorAll('.nav-links a');
window.addEventListener('scroll', () => {
    let current = '';
    sections.forEach(section => {
        if (window.scrollY >= section.offsetTop - 100) current = section.getAttribute('id');
    });
    navLinks.forEach(link => {
        link.classList.remove('active');
        if (link.getAttribute('href') === '#' + current) link.classList.add('active');
    });
});

// === HAMBURGER MENU ===
const hamburger = document.getElementById('hamburger');
const navLinksEl = document.getElementById('nav-links');
hamburger.addEventListener('click', () => {
    hamburger.classList.toggle('open');
    navLinksEl.classList.toggle('open');
});
navLinksEl.querySelectorAll('a').forEach(link => {
    link.addEventListener('click', () => {
        hamburger.classList.remove('open');
        navLinksEl.classList.remove('open');
    });
});

// === FADE-IN ANIMATIONS ON SCROLL ===
const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.classList.add('visible');
        }
    });
}, { threshold: 0.1 });
document.querySelectorAll('.f-card, .t-card, .testi-card, .stat-item, .faq-item').forEach(el => {
    el.classList.add('fade-in');
    observer.observe(el);
});

// === COUNTER ANIMATION ===
const counterObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            const counter = entry.target.querySelector('.counter');
            const target = parseInt(entry.target.getAttribute('data-target'));
            let current = 0;
            const step = target / 80;
            const timer = setInterval(() => {
                current += step;
                if (current >= target) { current = target; clearInterval(timer); }
                counter.textContent = Math.floor(current).toLocaleString();
            }, 20);
                counterObserver.unobserve(entry.target);
        }
    });
}, { threshold: 0.5 });
document.querySelectorAll('.stat-item').forEach(el => counterObserver.observe(el));

// === FAQ ACCORDION ===
document.querySelectorAll('.faq-question').forEach(btn => {
    btn.addEventListener('click', () => {
        const item = btn.parentElement;
        const isOpen = item.classList.contains('active');
        document.querySelectorAll('.faq-item').forEach(i => i.classList.remove('active'));
        if (!isOpen) item.classList.add('active');
    });
});

// === BILLING TOGGLE ===
document.getElementById('billing-toggle')?.addEventListener('change', function() {
    const price = document.getElementById('premium-price');
    if (price) price.innerHTML = this.checked ? '$7.99<span>/mo</span>' : '$9.99<span>/mo</span>';
});

// === THEME TOGGLE ===
const themeBtn = document.getElementById('theme-toggle');
themeBtn?.addEventListener('click', () => {
    document.body.classList.toggle('dark-mode');
    themeBtn.textContent = document.body.classList.contains('dark-mode') ? '☀️' : '🌙';
});

// === MODAL ===
function openModal() { document.getElementById('auth-modal').classList.add('active'); }
function closeModal() { document.getElementById('auth-modal').classList.remove('active'); }
function switchTab(tab) {
    const isSignup = tab === 'signup';
    document.querySelectorAll('.signup-only').forEach(el => el.style.display = isSignup ? '' : 'none');
    document.querySelector('.login-only').style.display = isSignup ? 'none' : '';
    document.getElementById('submit-btn').textContent = isSignup ? 'Create Account' : 'Log In';
    document.getElementById('signup-tab').classList.toggle('active', isSignup);
    document.getElementById('login-tab').classList.toggle('active', !isSignup);
}
function scrollToSection(id) { document.getElementById(id)?.scrollIntoView({ behavior: 'smooth' }); }
switchTab('login');

// ===== REVIEWS SYSTEM =====
        let reviews = [
            { id: 1, name: "Sarah M.", role: "Graphic Designer", feature: "Adaptive Sound Therapy", rating: 5, text: "ZenWave completely changed how I handle anxiety. The AI actually understands what I'm going through and the sound therapy is incredibly soothing.", date: "Mar 8, 2026", likes: 12 },
            { id: 2, name: "James K.", role: "Software Engineer", feature: "Mood Journaling", rating: 5, text: "I use the mood journaling every day now. The personalized insights helped me realize patterns in my emotional health I never noticed before.", date: "Feb 28, 2026", likes: 8 },
            { id: 3, name: "Priya R.", role: "Medical Student", feature: "Guided Breathing", rating: 4, text: "The guided breathing exercises have become part of my morning routine. I feel so much more focused and calm throughout the day.", date: "Feb 14, 2026", likes: 5 }
        ];
        let selectedRating = 0;
        let likedIds = new Set();
        let activeFilter = 'all';

        // Star picker
        const revStars = document.querySelectorAll('.rev-star');
        revStars.forEach(star => {
            star.addEventListener('mouseover', () => highlightRevStars(+star.dataset.val));
            star.addEventListener('mouseout',  () => highlightRevStars(selectedRating));
            star.addEventListener('click', () => { selectedRating = +star.dataset.val; highlightRevStars(selectedRating); });
        });
        function highlightRevStars(n) {
            revStars.forEach(s => s.classList.toggle('selected', +s.dataset.val <= n));
        }

        // Char counter
        document.getElementById('r-text')?.addEventListener('input', function() {
            document.getElementById('char-count').textContent = this.value.length;
        });

        function renderReviews() {
            const list = document.getElementById('reviews-list');
            const filtered = activeFilter === 'all' ? reviews : reviews.filter(r => r.rating === activeFilter);
            if (!filtered.length) {
                list.innerHTML = `<div class="rev-empty"><div style="font-size:44px;opacity:.3;margin-bottom:12px">🌿</div><p>No reviews for this rating yet.<br>Be the first!</p></div>`;
                return;
            }
            list.innerHTML = filtered.map((r, i) => `
                <div class="rev-card fade-in visible" style="animation-delay:${i * 0.07}s">
                    <div class="rev-card-top">
                        <div class="rev-author-info">
                            <div class="rev-avatar">${r.name.charAt(0)}</div>
                            <div>
                                <div class="rev-author-name">${r.name}</div>
                                <div class="rev-author-role">${r.role}</div>
                            </div>
                        </div>
                        <div style="text-align:right">
                            <div class="rev-stars-display">${'★'.repeat(r.rating)}${'☆'.repeat(5-r.rating)}</div>
                            <div class="rev-date">${r.date}</div>
                        </div>
                    </div>
                    <div class="rev-feature-tag">✨ ${r.feature}</div>
                    <p class="rev-text">${r.text}</p>
                    <div class="rev-helpful">
                        <span>Helpful?</span>
                        <button class="rev-helpful-btn ${likedIds.has(r.id) ? 'liked' : ''}" onclick="toggleRevLike(${r.id}, this)">👍 ${r.likes}</button>
                    </div>
                </div>
            `).join('');
        }

        function toggleRevLike(id, btn) {
            const r = reviews.find(r => r.id === id);
            if (likedIds.has(id)) { likedIds.delete(id); r.likes--; btn.classList.remove('liked'); }
            else { likedIds.add(id); r.likes++; btn.classList.add('liked'); }
            btn.textContent = `👍 ${r.likes}`;
        }

        function filterReviews(val, btn) {
            activeFilter = val === 'all' ? 'all' : +val;
            document.querySelectorAll('.rev-filter-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            renderReviews();
        }

        function updateReviewStats() {
            if (!reviews.length) return;
            const avg = (reviews.reduce((s, r) => s + r.rating, 0) / reviews.length).toFixed(1);
            document.getElementById('avg-score').textContent = avg;
            const filled = Math.round(avg);
            document.getElementById('avg-stars').textContent = '★'.repeat(filled) + '☆'.repeat(5 - filled);
            document.getElementById('review-count').textContent = `${reviews.length} review${reviews.length !== 1 ? 's' : ''}`;
            const counts = [5,4,3,2,1].map(n => ({ n, c: reviews.filter(r => r.rating === n).length }));
            document.getElementById('breakdown').innerHTML = counts.map(({n, c}) => `
                <div class="rev-bar-row">
                    <span style="min-width:18px;font-size:13px">${n}★</span>
                    <div class="rev-bar-track"><div class="rev-bar-fill" style="width:${reviews.length ? (c/reviews.length*100) : 0}%"></div></div>
                    <span style="font-size:13px;color:var(--m)">${c}</span>
                </div>
            `).join('');
        }

        function submitReview() {
            const name    = document.getElementById('r-name').value.trim();
            const role    = document.getElementById('r-role').value.trim();
            const feature = document.getElementById('r-feature').value;
            const text    = document.getElementById('r-text').value.trim();
            if (!name)    return shakeField('r-name');
            if (!role)    return shakeField('r-role');
            if (!feature) return shakeField('r-feature');
            if (!selectedRating) { document.getElementById('star-picker').style.animation='shake 0.4s ease'; setTimeout(()=>document.getElementById('star-picker').style.animation='',500); return; }
            if (!text)    return shakeField('r-text');

            const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
            const now = new Date();
            reviews.unshift({ id: Date.now(), name, role, feature, rating: selectedRating, text, date: `${months[now.getMonth()]} ${now.getDate()}, ${now.getFullYear()}`, likes: 0 });
            renderReviews();
            updateReviewStats();

            // Reset
            ['r-name','r-role','r-text'].forEach(id => document.getElementById(id).value = '');
            document.getElementById('r-feature').value = '';
            document.getElementById('char-count').textContent = '0';
            selectedRating = 0;
            highlightRevStars(0);

            // Toast
            const toast = document.getElementById('rev-toast');
            toast.classList.add('show');
            setTimeout(() => toast.classList.remove('show'), 3500);
        }

        function shakeField(id) {
            const el = document.getElementById(id);
            el.style.borderColor = '#ef4444';
            el.style.animation = 'shake 0.4s ease';
            setTimeout(() => { el.style.borderColor = ''; el.style.animation = ''; }, 800);
        }

        // Also observe new rev-cards for fade-in
        document.querySelectorAll('.rev-card').forEach(el => { el.classList.add('fade-in'); observer.observe(el); });

        renderReviews();
        updateReviewStats();

window.addEventListener('scroll', () => {
    let current = "";
    const sections = document.querySelectorAll('section, footer');
    const navLinks = document.querySelectorAll('.nav-links a');

    // Check if we are at the bottom of the page
    if ((window.innerHeight + window.scrollY) >= document.body.offsetHeight - 2) {
        current = "contact";
    } else {
        sections.forEach(section => {
            const sectionTop = section.offsetTop;
            if (pageYOffset >= sectionTop - 100) {
                current = section.getAttribute('id');
            }
        });
    }

    navLinks.forEach(link => {
        link.classList.remove('active');
        if (link.getAttribute('href').includes(current)) {
            link.classList.add('active');
        }
    });
});