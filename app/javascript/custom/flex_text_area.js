function flexTextarea(el) {
  const dummy = el.querySelector('.flex_text_area_dummy')
  el.querySelector('.flex_text_area_input_area').addEventListener('input', e => {
    dummy.textContent = e.target.value + '\u200b'
    console.log(dummy.textContent);
  })
}


document.addEventListener('turbo:load', () => {
  document.querySelectorAll('.flex_text_area').forEach(flexTextarea)
})
