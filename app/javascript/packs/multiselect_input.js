document.addEventListener("turbolinks:load", () => {
  document.querySelectorAll(".dropdown").forEach(function (element) {
    element.addEventListener("hide.bs.dropdown", function () {
      return false;
    });
  });

  document.querySelectorAll(".checkbox-menu").forEach(function (element) {
    element.addEventListener("click", function (event) {
      event.stopPropagation();
    });
  });
});
