class TaskReflex < StimulusReflex::Reflex
  before_reflex :set_task, only: [:toggle, :delete, :reorder]

  def toggle
    if @task.completed_at.present?
      @task.update!(completed_at: nil)
    else
      @task.update!(completed_at: Time.current)
    end
  end

  def delete
    @task.update(deleted_at: Time.current)
  end

  def reorder(position)
    @task.insert_at(position)
  end

  private

  def set_task
    @task = Task.find(element.dataset.id)
  end
end
