'turbo:load turbo:frame-load'.split(' ').forEach( (eName) => {
  document.addEventListener(eName, () => {
    const tweetImageUpload = document.getElementById('tweet_image');

    if (tweetImageUpload == null) {
      return;
    }

    tweetImageUpload.addEventListener('change', (e) => {
      const file = e.target.files[0];  
      const blob = window.URL.createObjectURL(file); 
      const tweetImageFrame = document.getElementById('tweetImageFrame');

      while (tweetImageFrame.firstChild) {
        tweetImageFrame.removeChild(tweetImageFrame.firstChild);
      }

      const tweetImage = document.createElement('img')
      tweetImage.src = blob;
      tweetImage.width = '100%';
      tweetImage.classList = 'rounded-4 my-2';
      tweetImageFrame.appendChild(tweetImage);

      const clearButton = document.createElement('button');
      clearButton.classList = 'px-2 py-1 rounded-circle text-secondary w-auto position-tweet-image-clear bg-black border-0 tweet-image-clear bg-opacity-50';
      clearButton.type = 'button';
      clearButton.id = 'tweetImageClear'
      tweetImageFrame.appendChild(clearButton);

      const clearIcon = document.createElement('i')
      clearIcon.classList = 'bi bi-x-lg text-white';
      clearButton.appendChild(clearIcon);

      const e_tweetImagePreviewd = new CustomEvent('tweetImagePreviewed');
      document.dispatchEvent(e_tweetImagePreviewd);
    });
  });
});