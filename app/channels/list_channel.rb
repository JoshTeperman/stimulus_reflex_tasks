class ListChannel < ApplicationCable::Channel
  def subscribed
    stream_for List.find_by(id: params[:list_id])
  end
end
