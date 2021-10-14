class ListReflex < StimulusReflex::Reflex
  delegate :current_user, to: :connection

  def create_task
    list = List.find(element.dataset.list_id)
    @new_task = list.tasks.create(**task_params.merge(creator: current_user))

    if @new_task.persisted?
      cable_ready[ListChannel]
        .insert_adjacent_html(
          selector: "#{dom_id(list)}_complete_tasks",
          position: 'beforeend',
          html: ApplicationController.render(@new_task)
        )
        .add_css_class(selector: "#{dom_id(list)} #no_tasks", name: 'd-none')
        .broadcast_to list

      @new_task = Task.new
    end
  end

  private

  def task_params
    params.require(:task).permit(:name)
  end
end
