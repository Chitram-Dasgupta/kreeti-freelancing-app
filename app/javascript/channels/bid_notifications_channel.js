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
        showAllButton.style.display = notificationBadge.textContent > 5 ? "block" : "none";

        const markAllAsReadButton = document.getElementById("markAllAsReadButton");
        markAllAsReadButton.style.display = notificationBadge.textContent > 0 ? "block" : "none";

        const deleteReadNotificationsButton = document.getElementById("deleteReadNotificationsButton");
        deleteReadNotificationsButton.style.display = notificationBadge.textContent > 0 ? "block" : "none";

        const notificationItem = createNotificationItem(data);
        notificationItem.addEventListener("click", function () {
          fetchWithCsrfToken(`/notifications/${data.notification_id}/mark_as_read`, "POST");
        });

        const notificationList = document.getElementById("notificationList");
        notificationList.insertBefore(notificationItem, notificationList.firstChild);
      }
    }
  );

  function createNotificationItem(data) {
    const notificationItem = document.createElement("a");
    notificationItem.classList.add("dropdown-item", "text-wrap");
    notificationItem.href = "/projects/" + data.project_id;
    notificationItem.textContent = `Your bid to ${data.bid_project_title} is ${data.bid_status}`;
    return notificationItem;
  }

  async function fetchWithCsrfToken(url, method) {
    const response = await fetch(url, {
      method: method,
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Content-Type": "application/json",
        Accept: "application/json"
      }
    });
    if (!response.ok) {
      throw new Error("Network response was not ok");
    }
    return await response.json();
  }
});
