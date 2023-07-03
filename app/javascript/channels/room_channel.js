import consumer from "./consumer";

document.addEventListener("turbolinks:load", () => {
  var messages = document.getElementById("messages");
  if (!messages) {
    return;
  }
  const roomId = messages.getAttribute("data-room-id");

  const currentUserId = document.querySelector("body").dataset.currentUserId;

  const messageStyles = {
    currentUser: {
      wrapperClasses: ["d-flex", "justify-content-start"],
      divClasses: ["bg-primary", "text-white", "rounded-pill", "px-3", "py-1", "mb-1", "mx-2"]
    },
    otherUser: {
      wrapperClasses: ["d-flex", "justify-content-end"],
      divClasses: ["bg-secondary", "text-white", "rounded-pill", "px-3", "py-1", "mb-1", "mx-2"]
    }
  };

  consumer.subscriptions.create(
    { channel: "RoomChannel", room_id: roomId },
    {
      connected() {},

      disconnected() {},

      received(data) {
        const style = data.user_id == currentUserId ? messageStyles.currentUser : messageStyles.otherUser;
        const messageElement = createMessageElement(data.content, style.wrapperClasses, style.divClasses);

        messages.appendChild(messageElement);
      }
    }
  );

  function createMessageElement(content, wrapperClasses, divClasses) {
    const messageWrapper = document.createElement("div");
    messageWrapper.classList.add(...wrapperClasses);

    const messageDiv = document.createElement("div");
    messageDiv.classList.add(...divClasses);

    const messageContent = document.createElement("p");
    messageContent.classList.add("mb-0");
    messageContent.textContent = content;

    messageDiv.appendChild(messageContent);
    messageWrapper.appendChild(messageDiv);

    return messageWrapper;
  }
});
