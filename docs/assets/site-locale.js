(() => {
  'use strict';

  const localizedPages = { ja: 'index.ja.html', 'zh-Hant': 'index.zh-Hant.html' };
  const explicitLanguage = new URLSearchParams(window.location.search).get('lang');
  if (explicitLanguage === 'en') return;

  let preferredLanguage;
  try { preferredLanguage = localStorage.getItem('monoashi-site-language'); } catch { /* Storage is optional. */ }

  if (!['en', 'ja', 'zh-Hant'].includes(preferredLanguage)) {
    preferredLanguage = undefined;
    const browserLanguages = navigator.languages?.length ? navigator.languages : [navigator.language];
    for (const locale of browserLanguages) {
      const tag = (locale || '').toLowerCase();
      if (/^en(?:-|$)/.test(tag)) preferredLanguage = 'en';
      if (/^ja(?:-|$)/.test(tag)) preferredLanguage = 'ja';
      if (/^zh-(?:hant|tw|hk|mo)(?:-|$)/.test(tag)) preferredLanguage = 'zh-Hant';
      if (preferredLanguage) break;
    }
  }

  const page = localizedPages[preferredLanguage];
  if (page) {
    const url = new URL(page, window.location.href);
    url.search = window.location.search;
    url.hash = window.location.hash;
    window.location.replace(url.href);
  }
})();
