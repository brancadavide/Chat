class ChatChannel < ApplicationCable::Channel
  
  def subscribed
			chat = ChatInfo.find params[:chat_id]
			update_read_messages_status chat.partner_chat
			stream_for chat
			update_messages(chat)
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
  			update_read_messages_status chat.partner_chat 
				update_messages chat
  	
  	elsif data['is_writing'] != nil
  			chat = ChatInfo.find(data['chat_id'].to_i)
  			
        if  chat.active
            chat.update(active: false)
            update_read_messages_status chat.partner_chat
            update_messages(chat)
        end
  			ChatChannel.broadcast_to partner_chat,is_writing: data['is_writing']
  		
  	end
	end

  private


  def update_read_messages_status(chat)
      chat.partner_chat.update(active: false)
      chat.partner_chat.messages.where(status: "new").each { |message| message.update(status: "ok") if !message.own }
      chat.messages.where(status: "sent").each { |message| message.update(status: "read") if message.own }
  end


  def update_messages(chat)
        ChatJob.perform_later(chat,40)
        ChatJob.perform_later(chat.partner_chat,40)
  end





end
