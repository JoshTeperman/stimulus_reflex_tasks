class TaskReflex < StimulusReflex::Reflex
  before_reflex :set_task, only: [:toggle, :delete, :reorder, :assign, :update]

  def toggle
    if element.checked
      @task.update!(completed_at: Time.current, completer: connection.current_user)
    else
      @task.update!(completed_at: nil, completer: nil)
    end

    cable_ready[ListChannel]
      .remove(selector: dom_id(@task))
      .insert_adjacent_html(
        selector: "#{dom_id(@task.list)}_#{element.checked ? 'complete_tasks' : 'incomplete_tasks'}",
        position: 'beforeend',
        html: ApplicationController.render(@task)
      )
      .broadcast_to @task.list
  end

  def delete
    @task.update(deleted_at: Time.current)

    cable_ready[ListChannel]
      .remove(selector: dom_id(@task))
      .broadcast_to @task.list

    if @task.list.tasks.active.empty?
      cable_ready[ListChannel]
        .remove_css_class(
          selector: "#{dom_id(@task.list)} #no_tasks",
          name: 'd-none'
        )
        .broadcast_to @task.list
    end
  end

  def reorder(position)
    @task.insert_at(position)
    morph :nothing
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
