window.addEventListener("turbolinks:load", function () {
  var user_role = document.querySelector("#user_role");

  if (user_role) {
    user_role.addEventListener("change", function () {
      var freelancer_fields = document.querySelector("#freelancer_fields");
      if (freelancer_fields) {
        freelancer_fields.style.display = this.value === "freelancer" ? "block" : "none";
      }
    });
  }
});
