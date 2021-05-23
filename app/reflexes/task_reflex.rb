class TaskReflex < StimulusReflex::Reflex
  def complete
    require 'pry';binding.pry
    Task.find(element.dataset.id).update!(completed_at: Time.current)
  end
end
