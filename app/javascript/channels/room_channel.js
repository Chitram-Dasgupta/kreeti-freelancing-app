import consumer from "./consumer";

document.addEventListener("turbolinks:load", () => {
  var messages = document.getElementById("messages");
  const roomId = messages.getAttribute("data-room-id");

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
        console.log(data.content);

        var newMessage = document.createElement("div");
        newMessage.textContent = data.content;
        messages.appendChild(newMessage);
      }
    }
  );
});
