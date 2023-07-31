document.addEventListener("turbolinks:load", function () {
  let flashMessages = document.querySelectorAll(".flashMessage");
  flashMessages.forEach(function (flashMessage, index) {
    let progressBar = flashMessage.querySelector(".progressBar");
    let width = 0.1;
    let interval = setInterval(frame, 5);
    function frame() {
      if (width >= 100) {
        clearInterval(interval);
        fadeOut(flashMessage);
      } else {
        width += 0.1;
        progressBar.style.width = width + "%";
      }
    }
  });
});

function fadeOut(element) {
  let op = 1;
  let timer = setInterval(function () {
    if (op <= 0.1) {
      clearInterval(timer);
      element.remove();
    }
    element.style.opacity = op;
    element.style.filter = "alpha(opacity=" + op * 100 + ")";
    op -= op * 0.1;
  }, 25);
}
