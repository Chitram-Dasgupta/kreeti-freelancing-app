import consumer from "./consumer";

document.addEventListener("turbolinks:load", () => {
  const currentUserId = document.querySelector("body").dataset.currentUserId;
  const notificationBadge = document.getElementById("notificationBadge");

  consumer.subscriptions.create("BidNotificationsChannel", {
    connected() {
      if (currentUserId != "") {
        fetch("/notifications/count")
          .then((response) => response.json())
          .then((data) => {
            notificationBadge.textContent = data.count;
          });

        loadNotifications();
      }
    },

    disconnected() {},

    received(data) {
      if (data.recipient_id == currentUserId) {
        const currentBadgeCount = parseInt(notificationBadge.textContent);
        notificationBadge.textContent = currentBadgeCount + 1;

        loadNotifications();
      }
    }
  });

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
});
