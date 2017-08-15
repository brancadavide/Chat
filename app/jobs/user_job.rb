class UserJob < ApplicationJob
  queue_as :default

  # current_user = the current_user-object
  # subscribed: boolean , user subscribed or unsubscribed
  def perform(current_user, subscribed=nil)

  		# update
  		 current_user.update(subscribed: subscribed) if subscribed != nil

  		# online users 
    	 users = User.all
    	
    	# formated object-array
    	
    	
    	# broadcast to each of the other user the updated informations
    	users.each do |user|
    			online_users_mapped = map_chat user.chat_infos
    			UserChannel.broadcast_to user, online_users: online_users_mapped, user: user
    	end
  
  end

  private

  def map_chat(chats)
  	chats.map {  |chat| { id: chat.id, email: chat.partner.email, subscribed: chat.partner.subscribed,unread_messages: chat.messages.where(status: "new").count,partner_id: chat.partner.id, subscribedClass: chat.partner.subscribedClass,active: chat.active }  }
  end



end
