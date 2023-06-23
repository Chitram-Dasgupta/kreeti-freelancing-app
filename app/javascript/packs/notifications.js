function fetchNotificationsCount() {
  const currentUserId = document.querySelector("body").dataset.currentUserId;
  const notificationBadge = document.getElementById("notificationBadge");

  if (currentUserId != "") {
    fetch("/notifications/count")
      .then((response) => response.json())
      .then((data) => {
        console.log(data.count);
        notificationBadge.innerText = data.count;
      });
  }
}

function loadNotifications() {
  const notificationList = document.getElementById("notificationList");

  fetch("/notifications/fetch_notifications")
    .then((response) => response.json())
    .then((notifications) => {
      notificationList.innerHTML = "";
      notifications.forEach((notification) => {
        const notificationItem = document.createElement("a");
        notificationItem.classList.add("dropdown-item");
        notificationItem.href = "/projects/" + notification.project_id;
        notificationItem.textContent = notification.message;

        notificationList.appendChild(notificationItem);
      });
    });
}

function fetchNotifications() {
  fetchNotificationsCount();
  loadNotifications();
}

document.addEventListener("turbolinks:load", fetchNotifications);
