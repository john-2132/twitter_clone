document.addEventListener('tweetImagePreviewed', () => {
  console.log('common baby!!');
  const tweetImageClear = document.getElementById('tweetImageClear');

  if (tweetImageClear == null) {
    return;
  }

  tweetImageClear.addEventListener('click', (e) => {
    const tweetImageFrame = document.getElementById('tweetImageFrame');

    while (tweetImageFrame.firstChild) {
      tweetImageFrame.removeChild(tweetImageFrame.firstChild);
    }

    const tweetImageUpload = document.getElementById('tweet_image');
    tweetImageUpload.value = '';
  });
});