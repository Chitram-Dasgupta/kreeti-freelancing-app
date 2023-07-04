function fetchNotificationsCount() {
  const notificationBadge = document.getElementById("notificationBadge");

  fetch("/notifications/count")
    .then((response) => response.json())
    .then((data) => {
      notificationBadge.innerText = data.count;
    });
}

function loadNotifications() {
  const notificationList = document.getElementById("notificationList");

  fetch("/notifications/fetch_notifications")
    .then((response) => response.json())
    .then((notifications) => {
      notificationList.innerHTML = "";
      notifications.forEach((notification) => {
        const notificationItem = document.createElement("a");
        notificationItem.classList.add("dropdown-item", "text-wrap");
        if(notification.read) {
          notificationItem.classList.add("text-muted");
        }
        notificationItem.href = "/projects/" + notification.project_id;
        notificationItem.textContent = notification.message;

        // ...
        notificationItem.addEventListener("click", function (event) {
          event.preventDefault();

          fetch(`/notifications/${notification.id}/mark_as_read`, {
            method: "POST",
            headers: {
              "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
              "Content-Type": "application/json",
              Accept: "application/json"
            }
          })
            .then((response) => {
              if (!response.ok) {
                throw new Error("Network response was not ok");
              }
              return response.json();
            })
            .then((data) => {
              if (data.success) {
                // Add a 'read' class to the notification item
                notificationItem.classList.add("text-muted");

                // Then navigate to the project page
                window.location.href = notificationItem.href;
              }
            })
            .catch((error) => {
              console.error("There has been a problem with your fetch operation:", error);
            });
        });
        // ...

        notificationList.appendChild(notificationItem);
      });
    });
}

function fetchNotifications() {
  const currentUserId = document.querySelector("body").dataset.currentUserId;
  if (currentUserId != "") {
    fetchNotificationsCount();
    loadNotifications();
  }
}

document.addEventListener("turbolinks:load", fetchNotifications);
