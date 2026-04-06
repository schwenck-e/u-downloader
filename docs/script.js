// Tab switching functionality
document.addEventListener('DOMContentLoaded', () => {
    // Tab switching
    const tabs = document.querySelectorAll('.tab');
    const tabContents = document.querySelectorAll('.tab-content');
    
    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            const targetTab = tab.getAttribute('data-tab');
            
            // Remove active class from all tabs and contents
            tabs.forEach(t => t.classList.remove('active'));
            tabContents.forEach(c => c.classList.remove('active'));
            
            // Add active class to clicked tab and corresponding content
            tab.classList.add('active');
            document.getElementById(targetTab).classList.add('active');
        });
    });
    
    // Copy button functionality
    const copyButtons = document.querySelectorAll('.copy-btn');
    
    copyButtons.forEach(btn => {
        btn.addEventListener('click', async () => {
            const codeId = btn.getAttribute('data-code');
            const codeElement = document.getElementById(codeId);
            const code = codeElement.textContent;
            
            try {
                await navigator.clipboard.writeText(code);
                
                // Visual feedback
                const originalText = btn.textContent;
                btn.textContent = 'Copied!';
                btn.classList.add('copied');
                
                setTimeout(() => {
                    btn.textContent = originalText;
                    btn.classList.remove('copied');
                }, 2000);
            } catch (err) {
                console.error('Failed to copy:', err);
                btn.textContent = 'Failed';
                setTimeout(() => {
                    btn.textContent = 'Copy';
                }, 2000);
            }
        });
    });
    
    // Smooth scroll for navigation links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            const href = this.getAttribute('href');
            
            // Don't prevent default for empty hash or just #
            if (href === '#' || href === '') return;
            
            e.preventDefault();
            const target = document.querySelector(href);
            
            if (target) {
                const headerOffset = 80;
                const elementPosition = target.getBoundingClientRect().top;
                const offsetPosition = elementPosition + window.pageYOffset - headerOffset;
                
                window.scrollTo({
                    top: offsetPosition,
                    behavior: 'smooth'
                });
            }
        });
    });
    
    // Mobile menu toggle
    const navToggle = document.querySelector('.nav-toggle');
    const navMenu = document.querySelector('.nav-menu');
    
    if (navToggle) {
        navToggle.addEventListener('click', () => {
            navMenu.classList.toggle('active');
        });
    }
    
    // Add scroll effect to header
    let lastScroll = 0;
    const header = document.querySelector('.header');
    
    window.addEventListener('scroll', () => {
        const currentScroll = window.pageYOffset;
        
        if (currentScroll <= 0) {
            header.style.boxShadow = 'none';
        } else {
            header.style.boxShadow = '0 2px 10px rgba(0, 0, 0, 0.1)';
        }
        
        lastScroll = currentScroll;
    });
    
    // Animate stats on scroll
    const observerOptions = {
        threshold: 0.5,
        rootMargin: '0px 0px -100px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);
    
    // Observe feature cards
    document.querySelectorAll('.feature-card, .doc-card, .example-card').forEach(card => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        card.style.transition = 'all 0.6s ease-out';
        observer.observe(card);
    });
    
    // Terminal animation
    animateTerminal();
});

function animateTerminal() {
    const terminalOutput = document.querySelector('.terminal-output');
    if (!terminalOutput) return;
    
    const originalContent = terminalOutput.textContent;
    terminalOutput.textContent = '';
    
    let index = 0;
    const speed = 20;
    
    function type() {
        if (index < originalContent.length) {
            terminalOutput.textContent += originalContent.charAt(index);
            index++;
            setTimeout(type, speed);
        }
    }
    
    // Start typing after a short delay
    setTimeout(type, 1000);
}

// Add keyboard shortcuts
document.addEventListener('keydown', (e) => {
    // Ctrl/Cmd + K to focus search (if implemented)
    if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
        e.preventDefault();
        // Implement search functionality here if needed
    }
});

// Analytics helper (optional - can be connected to Google Analytics)
function trackEvent(category, action, label) {
    if (window.gtag) {
        window.gtag('event', action, {
            event_category: category,
            event_label: label
        });
    }
}

// Track button clicks
document.querySelectorAll('.btn').forEach(btn => {
    btn.addEventListener('click', () => {
        const btnText = btn.textContent.trim();
        trackEvent('Button', 'Click', btnText);
    });
});

// Track copy events
document.querySelectorAll('.copy-btn').forEach(btn => {
    btn.addEventListener('click', () => {
        const codeType = btn.getAttribute('data-code');
        trackEvent('Code', 'Copy', codeType);
    });
});
