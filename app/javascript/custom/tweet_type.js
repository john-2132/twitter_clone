document.addEventListener('turbo:load', () => {
  const recommendedBtn = document.getElementById('recommendBtn');
  const followingBtn = document.getElementById('followingBtn');

  if (recommendedBtn == null || followingBtn == null) {
    return;
  }
  
  recommendedBtn.addEventListener('click', () => {
      recommendedBtn.classList.add('selected-100');
      followingBtn.classList.remove('selected-100');
  });
  
  followingBtn.addEventListener('click', () => {
      recommendedBtn.classList.remove('selected-100');
      followingBtn.classList.add('selected-100');
  });
});
