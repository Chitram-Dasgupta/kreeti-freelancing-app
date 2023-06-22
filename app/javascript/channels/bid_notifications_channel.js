import consumer from "./consumer";

document.addEventListener("turbolinks:load", () => {
  console.log("Loading bid_notifications_channel.js");

  const currentUserId = document.querySelector("body").dataset.currentUserId;

  console.log("Current user Id from <body> is: " + currentUserId);

  consumer.subscriptions.create("BidNotificationsChannel", {
    connected() {
      console.log("Connected to BidNotificationsChannel");

      fetch("/notifications/count")
        .then((response) => response.json())
        .then((data) => {
          const notificationBadge = document.getElementById("notificationBadge");
          notificationBadge.textContent = data.count;
        });

      loadNotifications();
    },

    disconnected() {},

    received(data) {
      console.log("Bid status changed: ", data.bid_id, data.bid_status);

      console.log("Current user Id from ruby server is: " + data.recipient_id);

      if (data.recipient_id == currentUserId) {
        const notificationBadge = document.getElementById("notificationBadge");
        const currentBadgeCount = parseInt(notificationBadge.textContent);

        if (currentBadgeCount === 0) {
          // Fetch notification count from the server
          fetch("/notifications/count")
            .then((response) => response.json())
            .then((data) => {
              if (data.count == 1) notificationBadge.textContent = data.count;
              else notificationBadge.textContent = data.count + 1;
            });
        } else {
          notificationBadge.textContent = currentBadgeCount + 1;
        }

        // loadNotifications(data);
        const bidStatusText = {
          accepted: "Accepted",
          rejected: "Rejected",
          pending: "Pending",
          awarded: "Awarded"
        };
        const notificationList = document.getElementById("notificationList");

        fetch("/notifications/fetch_notifications")
          .then((response) => response.json())
          .then((notifications) => {
            // Clear the current list and render the updated list
            notificationList.innerHTML = "";
            notifications.forEach((notification) => {
              const notificationItem = document.createElement("a");
              notificationItem.classList.add("dropdown-item");
              notificationItem.href = "/projects/" + notification.project_id;
              // notificationItem.textContent = `Your bid to ${notification.project.title} is changed to ${bidStatusText[notification.bid_status]} status`;
              notificationItem.textContent = notification.message;

              notificationList.appendChild(notificationItem);
              console.log(notification);
            });
          });
      }
    }
  });

  function loadNotifications(data) {
    const notificationList = document.getElementById("notificationList");

    fetch("/notifications/fetch_notifications")
      .then((response) => response.json())
      .then((notifications) => {
        // Clear the current list and render the updated list
        notificationList.innerHTML = "";
        notifications.forEach((notification) => {
          const notificationItem = document.createElement("a");
          notificationItem.classList.add("dropdown-item");
          notificationItem.href = "/projects/" + notification.project_id;
          // notificationItem.textContent = `Your bid to ${notification.project.title} is changed to ${bidStatusText[notification.bid_status]} status`;
          notificationItem.textContent = notification.message;

          notificationList.appendChild(notificationItem);
          console.log(notification);
        });
      });
  }
});
