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
