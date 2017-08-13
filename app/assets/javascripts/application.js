// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.de.js
//= require cable.js
//= require angular/angular 

// 

(function(){
		
		var app = angular.module("chat", []);
			
				// returns "online" if value true, otherwise "offline" 
				app.filter('online', function() {
					return(function(input){
						var input = input || false;
							return (input === true ? "Online" : "Offline");
					})
				});

				// returns "active" if value true, otherwise an empty string
				// used to add or remove class 'active', as notification when new messages have been received
				app.filter('activeState', function() {
					return(function(input){
						var input = input || false;
							return (input === true ? "active" : "");
					})
				});

				// returns "popover left" if value true, "popover right" if value false
				// used to display sent messages on the right hand and received on the left hand side
				app.filter('popoverClass', function() {
					return(function(input){
						var input = input || false;
							return (input === true ? "popover left " : "popover right");
					})
				});

				// returns "sent" if value true, "received" if value false
				// used to add a slightly different style to received and sent messages				
				app.filter('messageClass', function() {
					return(function(input){
						var input = input || false;
							return (input === true ? "sent " : "received");
					})
				});

				// translate 'sent' and 'read' into german
				app.filter('messageStatus', function() {
					return(function(status, time){
							var text;
							console.log(time);
							status === "sent" ? text = "Gesendet " : text = "Gelesen ";
							return text + time;
							
					})
				});
					
				// service to provide	ne chat-channel-instances, and stores the object to avoid multiple instances for on channel
				// getChannel: returns an object(the open channel) if exits
				// addChannel: stores a new channel
				// allChannels: returns an object containing all stored channel-objects
				// hasChannel: returns boolean wether the channel with the given id already exists or not

				app.factory('ChatChannels',function() {
					var chat_channels = {};
					return({
						getChannel: function(channel_id) {
							return chat_channels[channel_id];
						},
						addChannel: function(channel,channel_id) {
							chat_channels[channel_id] = channel;
						},
						allChannels: function() {
							return chat_channels;
						},
						hasChannel(channel_id) {
							return ( chat_channels[channel_id] != undefined || chat_channels[channel_id] === {} );
						}
					})
				});


				// stores 
				app.factory('OnlineStatus',function(){
					
					return {
						unsubscribe: function(appUser) {
							appUser.status(false);
							
						},
						subscribe: function(appUser) {
							appUser.status(true);
							
						}
					}
				});


				app.controller("UserController",function($scope,$http,ChatChannels,OnlineStatus){
					
					// stores the authenticity token required when submitting messages via post
					$scope.authenticity_token = $("meta[name='csrf-token']").attr('content');
					
					// stores the 'user-objects' to show a user list including their online-status
					$scope.online_users = [];

					// service 'ChatChanels' see above
					$scope.chat_channels = ChatChannels;

					// id of the current chat-channel
					$scope.current_chat_channel = 0;

					// username/email of the current chat_partner
					$scope.current_chat_partner = "";

					// currently displayed messages (ng-repeat="m in messages")
					$scope.messages = [];

					// if the message-input field is focused, the value changes to 'true' (ng-show)
					$scope.is_writing = false;

					$scope.onlineStatus = OnlineStatus;	

					// after pageload don't show the message-window as long no user to chat with is chosen(ng-show)
					$scope.chat_active = function() { 
							return ($scope.current_chat_channel > 0 );
					};


					// triggers a notification for the current chat-partner trough the channel 
					$scope.writing_message_notification = function(focus) {
						var chat_id = $scope.current_chat_channel
						$scope.chat_channels.getChannel(chat_id).send({ is_writing: focus, chat_id: chat_id })
					}

					// submit ne message via ajax, empty input field after submit
					$scope.submit = function() {
						$http.post("/welcome/message.json",JSON.stringify( { message: { body: $scope.message, chat_info_id: $scope.current_chat_channel }, authenticity_token: $scope.authenticity_token } ))
								 .then(function(response) {
											$scope.message = '';
								}); 
					}	

					$scope.chat_channel = function( chat_id) {
							if ($scope.chat_channels.hasChannel(chat_id)) {
									
									var chatChannel = $scope.chat_channels.getChannel(chat_id);
											chatChannel.send({ get_messages: chat_id })
							} else {

									var chatChannel=  App.cable.subscriptions.create({ channel: "ChatChannel",chat_id: chat_id }, {					

								  received: function(data) {
								    if(data.messages) {
								    	var object;

								    	for( var index =0 ; index < $scope.online_users.length ; index ++ ) {
								    			object = $scope.online_users[index];
								    			if ( object.id === data.partner.id && object.email === data.partner.email ) {
								    					$scope.online_users[index] = data.partner;
								    			}
								    	}

								    	$scope.$apply(function() {
								    		$scope.messages = data.messages;
								    		$scope.online_users;
								    	})	
								    } else if(data.is_writing !== undefined ) {
								    	$scope.$apply(function() {
								    		$scope.is_writing = data.is_writing;
								    	})	
								    		
								    }
								   
								  },								

									status: function(data) {
								    return this.perform('status',{ status: data });
								  }


								})

								$scope.chat_channels.addChannel(chatChannel, chat_id);
							
							}
							return chatChannel;	
					} 

					$scope.getChat = function(partner) {
						var partner = partner;

						$http({
							url: "/welcome/chat.json",
							method: "get",
							params: { partner_id: partner.partner_id }
							
						}).then(function(response) {
							var id = response.data.chat.id;
							var chat = $scope.chat_channel( id );
							$scope.current_chat_channel = id; 
					
							$scope.current_chat_partner = partner.email;
								
						});
					}					

					
					$scope.appUser = App.cable.subscriptions.create("UserChannel", {

					  status: function(status) {
					  	return this.perform('status', { subscribe: status})
					  },			

					  received: function(data) {
					  			console.log(data);
					  			if(data.online_users) {
									   			$scope.$apply(function() {
										   			$scope.online_users= data.online_users;
										  			$scope.status = data.user.subscribed;	
								  				});
								  } 
					 	}
				});

		});


})();

