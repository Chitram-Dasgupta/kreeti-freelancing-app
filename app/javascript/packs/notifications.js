function fetchNotificationsCount() {
  const notificationBadge = document.getElementById("notificationBadge");
  const showAllButton = document.getElementById("showAllButton");
  const markAllAsReadButton = document.getElementById("markAllAsReadButton");

  fetch("/notifications/count")
    .then((response) => response.json())
    .then((data) => {
      notificationBadge.innerText = data.count;
      console.log(data.count);
      if (data.full_count > 5) {
        showAllButton.style.display = "block";
        console.log("block display");
        console.log(showAllButton);
      } else {
        showAllButton.style.display = "none";
      }

      if(data.full_count > 0) {
        markAllAsReadButton.style.display = "block";
      } else {
        markAllAsReadButton.style.display = "none";
      }
    });
}

function loadNotifications(showAll = false) {
  const notificationList = document.getElementById("notificationList");
  let notificationContainer = document.getElementById("notificationContainer");

  if (showAll) {
    console.log(notificationList);
    console.log(notificationContainer);
  }

  if (!notificationContainer) {
    notificationContainer = document.createElement("div");
    notificationContainer.id = "notificationContainer";
    notificationList.insertBefore(notificationContainer, notificationList.firstChild);
  }

  notificationContainer.innerHTML = "";
  console.log(`/notifications/fetch_notifications${showAll ? "" : "?limit=5"}`);
  fetch(`/notifications/fetch_notifications${showAll ? "" : "?limit=5"}`)
    .then((response) => response.json())
    .then((notifications) => {
      notifications.forEach((notification) => {
        const notificationItem = document.createElement("a");
        notificationItem.classList.add("dropdown-item", "text-wrap");
        if (notification.read) {
          notificationItem.classList.add("text-muted");
        }
        notificationItem.href = "/projects/" + notification.project_id;
        notificationItem.textContent = notification.message;

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
    const notificationList = document.getElementById("notificationList");

    const showAllButton = document.createElement("button");
    showAllButton.id = "showAllButton";
    showAllButton.style.display = "none";
    showAllButton.classList.add("btn", "btn-primary", "btn-sm", "mx-1", "my-1");
    showAllButton.textContent = "Show All";
    showAllButton.addEventListener("click", function (event) {
      console.log("Clicked!");
      event.stopPropagation();

      loadNotifications(true);
    });
    notificationList.appendChild(showAllButton);

    const markAllAsReadButton = document.createElement("button");
    markAllAsReadButton.id = "markAllAsReadButton";
    showAllButton.style.display = "none";
    markAllAsReadButton.classList.add("btn", "btn-warning", "btn-sm", "mx-1", "my-1");
    markAllAsReadButton.textContent = "Mark All as Read";
    markAllAsReadButton.addEventListener("click", function (event) {
      event.stopPropagation();

      fetch(`/notifications/mark_all_as_read`, {
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
            const notificationItems = document.querySelectorAll(".dropdown-item");
            notificationItems.forEach((item) => {
              item.classList.add("text-muted");
            });
          }
        })
        .catch((error) => {
          console.error("There has been a problem with your fetch operation:", error);
        });
    });
    notificationList.appendChild(markAllAsReadButton);

    fetchNotificationsCount();
    loadNotifications();
  }
}

document.addEventListener("turbolinks:load", fetchNotifications);
