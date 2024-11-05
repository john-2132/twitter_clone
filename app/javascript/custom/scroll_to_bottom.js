'turbo:load turbo:frame-render after-message-render'.split(' ').forEach( (eName) => {
  document.addEventListener(eName, () => {
    const element = document.getElementById('scrollable-message');
    if (element == null) {
      return;
    }
    element.scrollTop = element.scrollHeight;
  });
});