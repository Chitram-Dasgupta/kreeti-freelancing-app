import consumer from "./consumer";

document.addEventListener("turbolinks:load", () => {
  const currentUserId = document.querySelector("body").dataset.currentUserId;
  const notificationBadge = document.getElementById("notificationBadge");

  consumer.subscriptions.create(
    { channel: "BidNotificationsChannel", user_id: currentUserId },
    {
      connected() {
        console.log(currentUserId);
      },

      disconnected() {},

      received(data) {
        console.log(data);
        const currentBadgeCount = parseInt(notificationBadge.textContent);
        notificationBadge.textContent = currentBadgeCount + 1;

        const showAllButton = document.getElementById("showAllButton");
        showAllButton.style.display = notificationBadge.textContent > 5 ? "block" : "none";

        const notificationItem = createNotificationItem(data);
        notificationItem.addEventListener("click", function () {
          fetchWithCsrfToken(`/notifications/${data.notification_id}/mark_as_read`, "POST");
        });

        const notificationList = document.getElementById("notificationList");
        notificationList.insertBefore(notificationItem, notificationList.firstChild);

        updateButtons();
      }
    }
  );

  function createNotificationItem(data) {
    const notificationItem = document.createElement("a");
    notificationItem.classList.add("dropdown-item", "text-wrap");
    notificationItem.href = "/projects/" + data.project_id;
    notificationItem.textContent = data.message;
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

  function updateButtons() {
    const notificationItems = document.querySelectorAll(".dropdown-item");
    const readItems = document.querySelectorAll(".dropdown-item.text-muted");
    const unreadItems = notificationItems.length - readItems.length;
    const markAllAsReadButton = document.getElementById("markAllAsReadButton");
    const deleteReadNotificationsButton = document.getElementById("deleteReadNotificationsButton");

    markAllAsReadButton.style.display = unreadItems > 0 ? "block" : "none";

    deleteReadNotificationsButton.style.display = readItems.length > 0 ? "block" : "none";
  }
});
