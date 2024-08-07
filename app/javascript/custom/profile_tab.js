document.addEventListener('turbo:load', () => {
  const tabs = [
    document.getElementById('postTab'),
    document.getElementById('replyTab'),
    document.getElementById('highlightTab'),
    document.getElementById('articleTab'),
    document.getElementById('mediaTab'),
    document.getElementById('favoriteTab')
  ];

  if (tabs.some(tab => tab === null)) {
    return;
  }

  tabs.forEach(tab => {
    tab.addEventListener('click', () => {
      tabs.forEach(t => t.classList.remove('selected-50'));
      tab.classList.add('selected-50');
    });
  });
});
