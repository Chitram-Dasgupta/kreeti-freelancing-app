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
        notificationItem.href = "/projects/" + notification.project_id;
        notificationItem.textContent = notification.message;

        // Add click event listener
        // ...
        // ...
        notificationItem.addEventListener("click", function () {
          fetch(`/notifications/${notification.id}/mark_as_read`, {
            method: "POST",
            headers: {
              "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
              "Content-Type": "application/json",
              Accept: "application/json"
            }
          });
        });
        // ...

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
