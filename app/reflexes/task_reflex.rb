class TaskReflex < StimulusReflex::Reflex
  def toggle
    id = element.id.split('_').last
    task = Task.find(id)

    if task.completed_at.present?
      task.update!(completed_at: nil)
    else
      task.update!(completed_at: Time.current)
    end
  end
end
