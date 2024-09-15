function flexTextarea(el) {
  const dummy = el.querySelector('.flex_text_area_dummy');
  el.querySelector('.flex_text_area_input_area').addEventListener('input', e => {
    dummy.textContent = e.target.value + '\u200b';
  });
};


'turbo:load turbo:frame-render after-stream-render'.split(' ').forEach( (eName) => {
  document.addEventListener(eName, () => {
    document.querySelectorAll('.flex_text_area').forEach(flexTextarea);
  });
});