document.addEventListener('turbo:load', () => {
  const side_menus = [
    document.getElementById('home'),
    document.getElementById('search'),
    document.getElementById('notify'),
    document.getElementById('message'),
    document.getElementById('bookmark'),
    document.getElementById('subscribe'),
    document.getElementById('more')
  ];

  avatarLink = document.getElementById('avatarLink');
  profile = document.getElementById('profile');

  if (side_menus.some(side_menu => side_menu === null) || avatarLink == null) {
    return;
  }

  avatarLink.addEventListener('turbo:click', () => {
    console.log('something moving', side_menus);
    side_menus.forEach(s => s.classList.remove('selected-sidemenu'));
    profile.classList.add('selected-sidemenu');
    // console.log(side_menu);
  });
});
