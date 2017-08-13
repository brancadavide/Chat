class ChatInfo < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy
  validates :user_id, uniqueness: { scope: :partner_id }

  def partner_chat
  	User.find(self.partner_id).chat_infos.where(partner_id: self.user_id).first
  end

  def partner
  	User.find self.partner_id
  end


end
