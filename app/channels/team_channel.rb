class TeamChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user.team
  end
end
