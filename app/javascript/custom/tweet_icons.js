'turbo:load turbo:frame-load after-tweet-render after-reply-render after-favorite-render after-retweet-render after-follow-render'.split(' ').forEach( (eName) => {
  document.addEventListener(eName, () => {
    // no-link クラスが付いたボタンのクリックイベントをリンクに伝播させない
    document.querySelectorAll('.no-link').forEach(function(button) {
      button.addEventListener('click', function(event) {
        event.stopPropagation();
      });
    });
  });
});