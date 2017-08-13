class UserChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user
    UserJob.perform_later(current_user, true)
  end

  def unsubscribed
     UserJob.perform_now(current_user, false)
  end

  def status(data)
  	UserJob.perform_later(current_user, data['subscribe'])
  end


end
