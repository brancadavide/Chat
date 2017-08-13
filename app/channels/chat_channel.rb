class ChatChannel < ApplicationCable::Channel
  
  def subscribed
			chat = ChatInfo.find params[:chat_id]
			chat.update(active: false)
			chat.partner_chat.messages.where(status: "sent").each { |message| message.update(status: "read") if message.own } 
			stream_for chat
			ChatJob.perform_later(chat, 40)
			ChatJob.perform_later(chat.partner_chat,40)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def status(status)

  end

  def receive(data)
  
  	if data['get_messages'] != nil
  			chat = ChatInfo.find(data['get_messages'].to_i)
  			chat.update(active: false)
  			chat.partner_chat.messages.where(status: "sent").each { |message| message.update(status: "read") if message.own } 
				ChatJob.perform_later(chat, 40)
				ChatJob.perform_later(chat.partner_chat,40)
  	
  	elsif data['is_writing'] != nil
  			user_chat = ChatInfo.find(data['chat_id'].to_i)
  			partner_chat = user_chat.partner_chat
        if user_chat.active
            user_chat.update(active: false)
            partner_chat.messages.where(status: "sent").each { |message| message.update(status: "read") if message.own } 
            ChatJob.perform_later(user_chat,40)
            ChatJob.perform_later(partner_chat,40)
        end
  			ChatChannel.broadcast_to partner_chat,is_writing: data['is_writing']
  		
  	end
	end





end
