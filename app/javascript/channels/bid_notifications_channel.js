import consumer from "./consumer";

console.log("Loading bid_notifications_channel.js");

consumer.subscriptions.create("BidNotificationsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("Connected to BidNotificationsChannel");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log("Bid status changed: ", data.bid_id, data.bid_status);

    // Create a new notification item
    const notificationItem = document.createElement("a");
    notificationItem.classList.add("dropdown-item");
    notificationItem.href = "#";
    notificationItem.textContent = `Bid ${data.bid_id} status changed to ${data.bid_status}`;

    // Append the notification item to the notification list
    const notificationList = document.getElementById("notificationList");
    notificationList.appendChild(notificationItem);

    // Update the notification badge count
    const notificationBadge = document.getElementById("notificationBadge");
    const currentBadgeCount = parseInt(notificationBadge.textContent);
    notificationBadge.textContent = currentBadgeCount + 1;
  }
});
