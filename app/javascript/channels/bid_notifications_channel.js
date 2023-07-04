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

        const notificationItem = document.createElement("a");
        notificationItem.classList.add("dropdown-item", "text-wrap");
        notificationItem.href = "/projects/" + data.project_id;
        notificationItem.textContent = `Your bid to ${data.bid_project_title} is ${data.bid_status}`;

        // ...
        notificationItem.addEventListener("click", function (event) {
          event.preventDefault();

          fetch(`/notifications/${data.notification_id}/mark_as_read`, {
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

        const notificationList = document.getElementById("notificationList");
        notificationList.insertBefore(notificationItem, notificationList.firstChild);
      }
    }
  );
});
