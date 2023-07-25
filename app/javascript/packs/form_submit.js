window.addEventListener("DOMContentLoaded", () => {
  var form = document.getElementById("message-form");

  if (!form) {
    return;
  }

  var submitButton = form.querySelector('button[type="submit"]');
  var messageInput = form.querySelector('input[name="message[content]"]');

  form.addEventListener("submit", function (event) {
    event.preventDefault();

    var formData = new FormData(form);

    messageInput.value = "";

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
          submitButton.disabled = false;
        } else {
          submitButton.disabled = false;
        }
      })
      .catch((_error) => {
        submitButton.disabled = false;
      });

    submitButton.disabled = true;
  });
});
