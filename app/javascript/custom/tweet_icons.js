'turbo:load turbo:frame-load after-favorite-render'.split(' ').forEach( (eName) => {
  document.addEventListener(eName, () => {
    // no-link クラスが付いたボタンのクリックイベントをリンクに伝播させない
    document.querySelectorAll('.no-link').forEach(function(button) {
      console.log('load');
      button.addEventListener('click', function(event) {
        console.log('no_link');
        event.stopPropagation();
      });
    });
  });
});