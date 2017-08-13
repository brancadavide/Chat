var users;

App.user = App.cable.subscriptions.create("UserChannel", {
  connected: function() {
    // Called when the subscription is ready for use on the server
  },

  disconnected: function() {
    // Called when the subscription has been terminated by the server
  },

  received: function(data) {
   users= data['users'];
});
