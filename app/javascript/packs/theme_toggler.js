window.addEventListener("turbolinks:load", function () {
  const toggler = document.getElementById("themeToggle");
  if (!toggler) {
    return;
  }

  const savedTheme = localStorage.getItem("theme");
  if (savedTheme) {
    applyTheme(savedTheme);
  }

  toggler.addEventListener("click", function () {
    const htmlEl = document.documentElement;
    const currentTheme = htmlEl.getAttribute("data-bs-theme");
    const newTheme = currentTheme === "light" ? "dark" : "light";

    localStorage.setItem("theme", newTheme);

    applyTheme(newTheme);
  });

  function applyTheme(theme) {
    const htmlEl = document.documentElement;
    htmlEl.setAttribute("data-bs-theme", theme);
    htmlEl.className = theme === "light" ? "bg-light" : "bg-secondary";

    if (theme === "dark") {
      toggler.innerHTML = '<i class="bi bi-sun-fill"></i>';
    } else {
      toggler.innerHTML = '<i class="bi bi-moon-stars-fill"></i>';
    }
  }
});
