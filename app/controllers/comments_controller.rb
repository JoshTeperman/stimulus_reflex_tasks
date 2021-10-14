class CommentsController < ApplicationController
  include CableReady::Broadcaster

  def create
    @task = Task.find_by(id: params[:task_id])
    comment = @task.comments.new(comment_params.merge(user: current_user))
    if comment.save
      cable_ready[TaskChannel].insert_adjacent_html(
        selector: '#comments',
        html: render_to_string(partial: comment)
      )
      cable_ready[TaskChannel].outer_html(
        selector: '#comments-create-form',
        focus_selector: "#comments-create-form textarea[name='comment[body]']",
        html: render_to_string(partial: 'comments/create_form', assigns: { new_comment: Comment.new, task: @task })
      )
    else
      cable_ready[TaskChannel].outer_html(
        selector: '#comments-create-form',
        focus_selector: "#comments-create-form textarea[name='comment[body]']",
        html: render_to_string(partial: 'comments/create_form', assigns: { new_comment: comment, task: @task })
      )
    end

    cable_ready.broadcast_to @task
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
