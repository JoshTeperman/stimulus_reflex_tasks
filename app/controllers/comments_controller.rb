class CommentsController < ApplicationController
  include CableReady::Broadcaster

  after_action :broadcast_to_current_user, only: [:create]

  def create
    @task = Task.find_by(id: params[:task_id])
    comment = @task.comments.new(comment_params.merge(user: current_user))
    if comment.save
      cable_ready[TaskChannel].insert_adjacent_html(
        selector: '#comments',
        html: render_to_string(partial: comment, assigns: { new_comment: Comment.new }),
        focus_selector: "#comments-create-form textarea[name='comment[body]']",
      )
      cable_ready[TaskChannel].set_value(
        selector: "#comments-create-form textarea[name='comment[body]']",
        value: ''
      )
    else
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def broadcast_to_current_user
    cable_ready.broadcast_to @task
  end
end
