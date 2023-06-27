import consumer from "./consumer";

consumer.subscriptions.create("RoomChannel", {
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

    var messages = document.getElementById("messages");
    var newMessage = document.createElement("div");
    newMessage.textContent = data.content;
    messages.appendChild(newMessage);
  }
});
