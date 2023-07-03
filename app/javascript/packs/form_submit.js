window.addEventListener("DOMContentLoaded", (event) => {
  var form = document.getElementById("message-form");

  if (!form) {
    return;
  }

  var submitButton = form.querySelector('button[type="submit"]'); // Select the submit button
  var messageInput = form.querySelector('input[name="message[content]"]'); // Select the text input field

  form.addEventListener("submit", function (event) {
    event.preventDefault(); // Prevent the form from being submitted normally

    var formData = new FormData(form);

    messageInput.value = ""; // Clear the text input field

    fetch(form.action, {
      method: "POST",
      body: formData,
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        Accept: "application/json"
      },
      credentials: "same-origin"
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.status === "ok") {
          submitButton.disabled = false; // Re-enable the submit button
        } else {
          console.error("Error:", data.errors);
          submitButton.disabled = false; // Re-enable the submit button in case of an error
        }
      })
      .catch((error) => {
        console.error("Error:", error);
        submitButton.disabled = false; // Re-enable the submit button in case of an error
      });

    submitButton.disabled = true;
  });
});
