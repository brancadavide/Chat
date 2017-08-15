class WelcomeController < ApplicationController
  before_action :authenticate_user!

  
  def index
  end

  respond_to :json

  def chat
  		partner = User.find(params[:partner_id])
  		user = current_user
  		@user_chat = getChat(user, partner)
  		partner_chat = getChat( partner, user)
  end

  def message
  		message_params = params[:message]
  		user_chat = ChatInfo.find(message_params[:chat_info_id])
  		partner = User.find(user_chat.partner_id)
  		partner_chat = partner.chat_infos.where(partner_id: current_user.id).first

  		user_message = user_chat.messages.build(body: message_params[:body],status: "sent", user_id: current_user.id)
  		partner_message = partner_chat.messages.build(body: message_params[:body],status: "new", user_id: current_user.id)

  		respond_to do |f|
  				if user_message.save and partner_message.save

  						f.json { render json: { notify: "Message sent"}, status: :ok }
  				else

  						f.json { render json: { errors: { partner_message: partner_message.errors, user_message: user_message.errors }  }, status: :unprocessible_entity }
  			end
  		end

  end 


  private

  def getChat(user, partner)
  	if user.chat_infos.where(partner_id: partner.id).first == nil 
  			chat = user.chat_infos.build(partner_id: partner.id)
  			chat.save
  	else
  		chat = user.chat_infos.where(partner_id: partner.id).first
  	end
  	return chat
  end

end
