(() => {
  'use strict';

  const root = document.documentElement;
  const themeToggle = document.querySelector('.theme-toggle');
  const systemTheme = window.matchMedia('(prefers-color-scheme: dark)');
  let savedTheme = null;
  try { savedTheme = localStorage.getItem('monoashi-site-theme'); } catch { /* Storage is optional. */ }

  const applyTheme = (theme) => {
    root.dataset.theme = theme;
    const dark = theme === 'dark';
    themeToggle.setAttribute('aria-label', `切換為${dark ? '淺' : '深'}色主題`);
    themeToggle.querySelector('use').setAttribute('href', dark ? '#i-sun' : '#i-moon');
    document.querySelector('meta[name="theme-color"]').content = dark ? '#0e1513' : '#006a60';
  };
  applyTheme(savedTheme === 'light' || savedTheme === 'dark' ? savedTheme : systemTheme.matches ? 'dark' : 'light');
  themeToggle.addEventListener('click', () => {
    savedTheme = root.dataset.theme === 'dark' ? 'light' : 'dark';
    applyTheme(savedTheme);
    try { localStorage.setItem('monoashi-site-theme', savedTheme); } catch { /* Keep the in-memory preference. */ }
  });
  systemTheme.addEventListener('change', ({ matches }) => {
    if (!savedTheme) applyTheme(matches ? 'dark' : 'light');
  });

  const menuToggle = document.querySelector('.menu-toggle');
  const nav = document.querySelector('.main-nav');
  const setMenu = (open) => {
    menuToggle.setAttribute('aria-expanded', String(open));
    menuToggle.setAttribute('aria-label', open ? '關閉導覽選單' : '開啟導覽選單');
    menuToggle.querySelector('use').setAttribute('href', open ? '#i-close' : '#i-menu');
    nav.classList.toggle('is-open', open);
  };
  menuToggle.addEventListener('click', () => setMenu(menuToggle.getAttribute('aria-expanded') !== 'true'));
  nav.addEventListener('click', (event) => { if (event.target.closest('a')) setMenu(false); });
  document.addEventListener('click', (event) => {
    if (!event.target.closest('.header-inner')) setMenu(false);
  });
  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape' && menuToggle.getAttribute('aria-expanded') === 'true') {
      setMenu(false);
      menuToggle.focus();
    }
  });
  window.matchMedia('(min-width: 861px)').addEventListener('change', ({ matches }) => { if (matches) setMenu(false); });

  const tabs = [...document.querySelectorAll('[role="tab"]')];
  const activateTab = (tab, focus = false) => {
    tabs.forEach((item) => {
      const selected = item === tab;
      item.setAttribute('aria-selected', String(selected));
      item.tabIndex = selected ? 0 : -1;
      document.getElementById(item.getAttribute('aria-controls')).hidden = !selected;
    });
    if (focus) tab.focus();
  };
  tabs.forEach((tab, index) => {
    tab.addEventListener('click', () => activateTab(tab));
    tab.addEventListener('keydown', (event) => {
      let next;
      if (event.key === 'ArrowRight') next = (index + 1) % tabs.length;
      if (event.key === 'ArrowLeft') next = (index - 1 + tabs.length) % tabs.length;
      if (event.key === 'Home') next = 0;
      if (event.key === 'End') next = tabs.length - 1;
      if (next !== undefined) { event.preventDefault(); activateTab(tabs[next], true); }
    });
  });

  // Native details/summary and ordinary image links also work without JavaScript.
  const dialog = document.querySelector('.preview-dialog');
  document.querySelectorAll('[data-preview]').forEach((link) => {
    link.addEventListener('click', (event) => {
      if (typeof dialog.showModal !== 'function' || event.ctrlKey || event.metaKey || event.shiftKey || event.altKey) return;
      event.preventDefault();
      const image = link.querySelector('img');
      const preview = dialog.querySelector('img');
      preview.src = link.getAttribute('href');
      preview.alt = image.alt;
      preview.width = image.width;
      preview.height = image.height;
      dialog.querySelector('p').textContent = link.dataset.caption;
      dialog.showModal();
    });
  });
  document.querySelector('.dialog-close').addEventListener('click', () => dialog.close());
  dialog.addEventListener('click', (event) => {
    if (event.target !== dialog) return;
    const rect = dialog.getBoundingClientRect();
    if (event.clientX < rect.left || event.clientX > rect.right || event.clientY < rect.top || event.clientY > rect.bottom) dialog.close();
  });

  const sectionLinks = [...nav.querySelectorAll('a')];
  if ('IntersectionObserver' in window) {
    const observer = new IntersectionObserver((entries) => {
      entries.forEach((entry) => {
        const link = sectionLinks.find((item) => item.hash === `#${entry.target.id}`);
        if (!link) return;
        if (entry.isIntersecting) {
          sectionLinks.forEach((item) => item.removeAttribute('aria-current'));
          link.setAttribute('aria-current', 'location');
        } else if (link.getAttribute('aria-current') === 'location') {
          link.removeAttribute('aria-current');
        }
      });
    }, { rootMargin: '-15% 0px -45% 0px' });
    sectionLinks.forEach((link) => { const section = document.querySelector(link.hash); if (section) observer.observe(section); });
  }
})();
