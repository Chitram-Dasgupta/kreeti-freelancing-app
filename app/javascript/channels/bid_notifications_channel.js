import consumer from "./consumer";

document.addEventListener("turbolinks:load", () => {
  const currentUserId = document.querySelector("body").dataset.currentUserId;
  const notificationBadge = document.getElementById("notificationBadge");

  consumer.subscriptions.create(
    { channel: "BidNotificationsChannel", user_id: currentUserId },
    {
      connected() {},

      disconnected() {},

      received(data) {
        const currentBadgeCount = parseInt(notificationBadge.textContent);
        notificationBadge.textContent = currentBadgeCount + 1;

        const showAllButton = document.getElementById("showAllButton");
        if (notificationBadge.textContent > 5) {
          showAllButton.style.display = "block";
        }

        const notificationItem = document.createElement("a");
        notificationItem.classList.add("dropdown-item", "text-wrap");
        notificationItem.href = "/projects/" + data.project_id;
        notificationItem.textContent = `Your bid to ${data.bid_project_title} is ${data.bid_status}`;

        notificationItem.addEventListener("click", function () {
          fetch(`/notifications/${data.notification_id}/mark_as_read`, {
            method: "POST",
            headers: {
              "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
              "Content-Type": "application/json",
              Accept: "application/json"
            }
          });
        });

        const notificationList = document.getElementById("notificationList");
        notificationList.insertBefore(notificationItem, notificationList.firstChild);
      }
    }
  );
});
