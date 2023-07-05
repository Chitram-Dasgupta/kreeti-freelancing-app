function fetchNotificationsCount() {
  const notificationBadge = document.getElementById("notificationBadge");
  const showAllButton = document.getElementById("showAllButton");
  const markAllAsReadButton = document.getElementById("markAllAsReadButton");
  const deleteReadNotificationsButton = document.getElementById("deleteReadNotificationsButton");

  fetch("/notifications/count")
    .then((response) => response.json())
    .then((data) => {
      notificationBadge.innerText = data.count;
      showAllButton.style.display = data.full_count > 5 ? "block" : "none";
      markAllAsReadButton.style.display = data.full_count > 0 ? "block" : "none";
      deleteReadNotificationsButton.style.display = data.full_count - data.count > 0 ? "block" : "none";
    });
}

function loadNotifications(showAll = false) {
  const notificationList = document.getElementById("notificationList");
  let notificationContainer = document.getElementById("notificationContainer");

  if (!notificationContainer) {
    notificationContainer = document.createElement("div");
    notificationContainer.id = "notificationContainer";
    notificationList.insertBefore(notificationContainer, notificationList.firstChild);
  }

  notificationContainer.innerHTML = "";
  fetch(`/notifications/fetch_notifications${showAll ? "" : "?limit=5"}`)
    .then((response) => response.json())
    .then((notifications) => {
      notifications.forEach((notification) => {
        const notificationItem = createNotificationItem(notification);

        notificationItem.addEventListener("click", function (event) {
          event.preventDefault();

          fetch(`/notifications/${notification.id}/mark_as_read`, {
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
                notificationItem.classList.add("text-muted");
                window.location.href = notificationItem.href;
              }
            })
            .catch((error) => {
              console.error("There has been a problem with your fetch operation:", error);
            });
        });

        notificationContainer.appendChild(notificationItem);
      });
    });
}

function fetchNotifications() {
  const currentUserId = document.querySelector("body").dataset.currentUserId;

  if (currentUserId != "") {
    addClickListener(document.getElementById("showAllButton"), function () {
      loadNotifications(true);
      showAllButton.style.display = "none";
    });

    addClickListener(document.getElementById("markAllAsReadButton"), function () {
      fetchWithCsrfToken("/notifications/mark_all_as_read", "POST")
        .then((data) => {
          if (data.success) {
            const notificationItems = document.querySelectorAll(".dropdown-item");
            const notificationBadge = document.getElementById("notificationBadge");
            notificationItems.forEach((item) => {
              item.classList.add("text-muted");
            });
            notificationBadge.innerText = 0;
          }
        })
        .catch((error) => {
          console.error("There has been a problem with your fetch operation:", error);
        });
    });

    addClickListener(document.getElementById("deleteReadNotificationsButton"), function () {
      fetchWithCsrfToken("/notifications/delete_read", "POST")
        .then((data) => {
          if (data.success) {
            const notificationItems = document.querySelectorAll(".dropdown-item.text-muted");
            notificationItems.forEach((item) => {
              item.remove();
            });
          }
        })
        .catch((error) => {
          console.error("There has been a problem with your fetch operation:", error);
        });
    });

    fetchNotificationsCount();
    loadNotifications();
  }
}

document.addEventListener("turbolinks:load", fetchNotifications);

function createButton(id, textContent, btnClass) {
  const button = document.createElement("button");
  button.id = id;
  button.style.display = "none";
  button.classList.add("btn", btnClass, "btn-sm", "mx-1", "my-1");
  button.textContent = textContent;
  return button;
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

function addClickListener(button, callback) {
  button.addEventListener("click", function (event) {
    event.stopPropagation();
    callback();
  });
}

function createNotificationItem(notification) {
  const notificationItem = document.createElement("a");
  notificationItem.classList.add("dropdown-item", "text-wrap");
  if (notification.read) {
    notificationItem.classList.add("text-muted");
  }
  notificationItem.href = "/projects/" + notification.project_id;
  notificationItem.textContent = notification.message;
  return notificationItem;
}
