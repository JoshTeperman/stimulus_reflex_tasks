class TaskReflex < StimulusReflex::Reflex
  before_reflex :set_task, only: [:toggle, :delete, :reorder, :assign]

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
    require 'pry';binding.pry
    @task.update!(assignee_id: element.value)
    morph "#task-#{@task.id}-assignee", @task.assignee_name
  end

  private

  def set_task
    @task = Task.find(element.dataset.id)
  end
end
