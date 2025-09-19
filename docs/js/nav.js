(() => {
  const html = document.documentElement;
  const toggle = document.getElementById('navToggle');
  const nav = document.getElementById('siteNav');

  if (!toggle || !nav) return;

  function openNav() {
    nav.removeAttribute('hidden');
    toggle.setAttribute('aria-expanded', 'true');
    html.classList.add('nav-open');
    // trap focus: put focus on first link
    const firstLink = nav.querySelector('a');
    if (firstLink) firstLink.focus();
  }

  function closeNav() {
    nav.setAttribute('hidden', '');
    toggle.setAttribute('aria-expanded', 'false');
    html.classList.remove('nav-open');
    toggle.focus();
  }

  toggle.addEventListener('click', () => {
    const expanded = toggle.getAttribute('aria-expanded') === 'true';
    expanded ? closeNav() : openNav();
  });

  // Close on Escape
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && nav && !nav.hasAttribute('hidden')) closeNav();
  });

  // Close when clicking outside nav
  document.addEventListener('click', (e) => {
    if (!nav.contains(e.target) && !toggle.contains(e.target) && !nav.hasAttribute('hidden')) {
      closeNav();
    }
  });
})();
