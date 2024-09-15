'turbo:load turbo:frame-render'.split(' ').forEach( (eName) => {
  document.addEventListener(eName, () => {
    const headerUpload = document.getElementById('profile_header');
    const avatarUpload = document.getElementById('profile_avatar');

    if (headerUpload == null || avatarUpload == null) {
      return;
    }

    headerUpload.addEventListener('change', (e) => {
      const file = e.target.files[0];  
      const blob = window.URL.createObjectURL(file); 
      const headerImage = document.getElementById('headerImage');
      const headerImageWidth = headerImage.width;
      const headerImageHeight = headerImage.height;
      headerImage.src = blob;
      headerImage.width = headerImageWidth;
      headerImage.height = headerImageHeight;
    });

    avatarUpload.addEventListener('change', (e) => {
      const file = e.target.files[0];  
      const blob = window.URL.createObjectURL(file); 
      const avatarImage = document.getElementById('avatarImage');
      const avatarImageWidth = avatarImage.offsetWidth;
      const avatarImageHeight = avatarImage.offsetHeight;
      console.log(avatarImageWidth, avatarImageHeight);
      avatarImage.src = blob;
      avatarImage.width = avatarImageWidth;
      avatarImage.height = avatarImageHeight;
    });
  });
});