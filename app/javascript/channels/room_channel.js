import consumer from "./consumer";

document.addEventListener("turbolinks:load", () => {
  var messages = document.getElementById("messages");
  const roomId = messages.getAttribute("data-room-id");

  const currentUserId = document.querySelector("body").dataset.currentUserId;

  consumer.subscriptions.create(
    { channel: "RoomChannel", room_id: roomId },
    {
      connected() {
        // Called when the subscription is ready for use on the server
        console.log("connected to room channel");
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        // Called when there's incoming data on the websocket for this channel
        console.log(data);
        console.log(data.content);

        if (data.user_id != currentUserId) {
          const newMessage = document.createElement("p");
          newMessage.classList.add(data.user_id === currentUserId ? "text-start" : "text-end");
          newMessage.textContent = data.content;

          messages.appendChild(newMessage);
        }
      }
    }
  );
});
