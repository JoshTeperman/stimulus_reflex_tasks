class TasksController < ApplicationController
  def show
    list = List.find_by(id: params[:list_id])
    @task = list.tasks.includes(:comments).find_by(id: params[:id])
    @new_comment = Comment.new
  end
end
