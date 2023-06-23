import consumer from "./consumer";

document.addEventListener("turbolinks:load", () => {
  const currentUserId = document.querySelector("body").dataset.currentUserId;
  const notificationBadge = document.getElementById("notificationBadge");

  consumer.subscriptions.create("BidNotificationsChannel", {
    connected() {},

    disconnected() {},

    received(data) {
      if (data.recipient_id == currentUserId) {
        const currentBadgeCount = parseInt(notificationBadge.textContent);
        notificationBadge.textContent = currentBadgeCount + 1;

        const notificationItem = document.createElement("a");
        notificationItem.classList.add("dropdown-item");
        notificationItem.href = "/projects/" + data.project_id;
        notificationItem.textContent = `Your bid to ${data.bid_project_title} is ${data.bid_status}`;

        const notificationList = document.getElementById("notificationList");
        notificationList.insertBefore(notificationItem, notificationList.firstChild);
      }
    }
  });
});
