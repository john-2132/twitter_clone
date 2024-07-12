document.addEventListener('turbo:load', () => {
  const recommendedBtn = document.getElementById('recommendBtn');
  const followingBtn = document.getElementById('followingBtn');
  
  recommendedBtn.addEventListener('click', () => {
      recommendedBtn.classList.add('selected');
      followingBtn.classList.remove('selected');
  });
  
  followingBtn.addEventListener('click', () => {
      recommendedBtn.classList.remove('selected');
      followingBtn.classList.add('selected');
  });
});
