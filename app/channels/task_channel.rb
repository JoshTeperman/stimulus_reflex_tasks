class TaskChannel < ApplicationCable::Channel
  def subscribed
    stream_for Task.find(params[:task_id])
  end
end
