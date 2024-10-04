document.addEventListener('show.bs.dropdown', function (event) {
  var dropdowns = document.querySelectorAll('.dropdown-menu.show');
  dropdowns.forEach(function (dropdown) {
    if (dropdown !== event.target) {
      dropdown.classList.remove('show');
    }
  });
});