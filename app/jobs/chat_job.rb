class ChatJob < ApplicationJob
  queue_as :default

  def perform(chat,limit)
  	messages = chat.messages
    ChatChannel.broadcast_to chat, messages: get_messages(messages), partner:{ id: chat.id, email: chat.partner.email, subscribed: chat.partner.subscribed,partner_id: chat.partner.id, subscribedClass: chat.partner.subscribedClass,active: chat.active } 
  end


  private

	def get_messages(messages,limit=40)
			messages.limit(limit).map { |message| { body: message.body, id: message.id, status: message.status, own: message.own, written_at: message.written_at, status_at: message.status_at } }
	end


end
