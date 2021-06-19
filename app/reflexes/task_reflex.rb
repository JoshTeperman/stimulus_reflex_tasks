class TaskReflex < StimulusReflex::Reflex
  def toggle
    task = Task.find(element.dataset.id)

    if task.completed_at.present?
      task.update!(completed_at: nil)
    else
      task.update!(completed_at: Time.current)
    end
  end

  def delete(id)
    task = Task.find(id)
    task.update(deleted_at: Time.current)
  end
end
