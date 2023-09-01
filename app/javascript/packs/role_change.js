window.addEventListener("turbolinks:load", function () {
  var user_role = document.querySelector("#user_role");

  if (user_role) {
    var toggleFreelancerFields = function () {
      var freelancer_fields = document.querySelector("#freelancer_fields");
      if (freelancer_fields) {
        freelancer_fields.style.display = user_role.value === "freelancer" ? "block" : "none";
      }
    };

    toggleFreelancerFields();

    user_role.addEventListener("change", toggleFreelancerFields);
  }
});
