class ListReflex < StimulusReflex::Reflex
  delegate :current_user, to: :connection

  def create_task
    list = List.find(element.dataset.list_id)
    @new_task = list.tasks.create(**task_params.merge(creator: current_user))
    @new_task = Task.new if @new_task.persisted?
  end

  private

  def task_params
    params.require(:task).permit(:name)
  end
end
