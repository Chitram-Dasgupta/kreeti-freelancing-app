window.addEventListener("DOMContentLoaded", (event) => {
  var form = document.getElementById("message-form");
  var submitButton = form.querySelector('input[type="submit"]');

  form.addEventListener("submit", function (event) {
    event.preventDefault(); // Prevent the form from being submitted normally

    var formData = new FormData(form);

    fetch(form.action, {
      method: "POST",
      body: formData,
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        Accept: "text/javascript"
      },
      credentials: "same-origin"
    })
      .then((response) => response.text())
      .then((data) => {
        eval(data);
        submitButton.disabled = false; // Re-enable the submit button
      })
      .catch((error) => {
        console.error("Error:", error);
        submitButton.disabled = false; // Re-enable the submit button in case of an error
      });

    submitButton.disabled = true; // Disable the submit button when the form is submitted
  });
});
