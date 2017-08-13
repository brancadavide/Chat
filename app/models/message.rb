class Message < ApplicationRecord
  belongs_to :chat_info

  def own
  	self.chat_info.user_id == self.user_id
  end

  def written_at
    get_time(self.created_at)
  end

  def status_at
    get_time(self.updated_at)
  end



  after_create :push_to_user
 
  private

  def push_to_user

    ChatJob.perform_now self.chat_info,40
    if !own 
      partner = User.find(self.chat_info.user_id)
      partner_chat = self.chat_info
      partner_chat.update(active: true)
      UserJob.perform_later(partner)
    end
  end

   def since_midnight
    self.created_at.seconds_since_midnight.to_i > Time.now.seconds_since_midnight.to_i
  end

  def hour
    60 * 60
  end

  def day 
    hour * 24
  end

  def get_time(time) 
    now = Time.now.to_i 
    time_i = time.to_i
    if (now - day) >= time_i and (now - (2* day)) < time_i
      return "gestern um #{time.strftime("%H:%M")}"
    elsif (now - day) < time_i
        if since_midnight == true
          return "gestern um #{time.strftime("%H:%M")}"
        else
         return "um #{time.strftime("%H:%M")}"
        end
    else
      return "am #{time.strftime("%d.%m.%Y um %H:%M")}"
    end
       
  end

   

  

  

end
