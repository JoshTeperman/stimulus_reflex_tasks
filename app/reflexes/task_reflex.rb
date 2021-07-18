class TaskReflex < StimulusReflex::Reflex
  before_reflex :set_task, only: [:toggle, :delete, :reorder, :assign, :update]

  def toggle
    if element.checked
      @task.update!(completed_at: Time.current, completer: connection.current_user)
    else
      @task.update!(completed_at: nil, completer: nil)
    end
  end

  def delete
    @task.update(deleted_at: Time.current)
  end

  def reorder(position)
    @task.insert_at(position)
  end

  def assign
    @task.update!(assignee_id: element.value)
    morph "#task-#{@task.id}-assignee", @task.assignee_name
  end

  def update
    @task.update(name: task_params[:name])
    morph dom_id(@task), ApplicationController.render(@task)
  end

  private

  def set_task
    @task = Task.find(element.dataset.id)
  end

  def task_params
    params.require(:task).permit(:name)
  end
end
