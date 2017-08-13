class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :chat_infos

  def subscribedClass 
  	self.subscribed ? "user-subscribed" : ""
  end

  def update_user_chats
  	set_chats
  end

  after_create :set_chats

  private

  def set_chats
  	User.where.not(id: self.id).each do |user|
  		user.chat_infos.build(partner_id: self.id).save
  		self.chat_infos.build(partner_id: user.id).save
  	end

  end


end
