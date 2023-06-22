import consumer from "./consumer";

document.addEventListener("turbolinks:load", () => {
  console.log("Loading bid_notifications_channel.js");

  const currentUserId = document.querySelector("body").dataset.currentUserId;

  console.log("Current user Id from <body> is: " + currentUserId);

  consumer.subscriptions.create("BidNotificationsChannel", {
    connected() {
      console.log("Connected to BidNotificationsChannel");
    },

    disconnected() {
    },

    received(data) {
      console.log("Bid status changed: ", data.bid_id, data.bid_status);

      console.log("Current user Id from ruby server is: " + data.recipient_id);

      if (data.recipient_id == currentUserId) {
        const notificationItem = document.createElement("a");
        notificationItem.classList.add("dropdown-item");
        notificationItem.href = "/projects/" + data.project_id;
        notificationItem.textContent = `Your bid to ${data.bid_project_title} is changed to ${data.bid_status} status`;

        const notificationList = document.getElementById("notificationList");
        notificationList.appendChild(notificationItem);

        const notificationBadge = document.getElementById("notificationBadge");
        const currentBadgeCount = parseInt(notificationBadge.textContent);
        notificationBadge.textContent = currentBadgeCount + 1;
      }
    }
  });
});
