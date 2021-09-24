class ListsController < ApplicationController
  include CableReady::Broadcaster

  def index
    @lists = List.all
    @new_task ||= Task.new
  end

  def new
    cable_ready[ListsChannel].insert_adjacent_html(
      selector: '#lists',
      focus_selector: '#lists-create-form .list-name-input',
      html: render_to_string(partial: 'lists/create_form', locals: { list: List.new })
    )

    cable_ready.broadcast_to(current_user)
  end

  def create
    @list = List.new(list_params)

    if @list.save
      cable_ready[ListsChannel].replace(
        selector: '#lists-create-form',
        focus_selector: "#{dom_id(@list)} .task-name-input",
        html: render_to_string(@list, assigns: { new_task: Task.new })
      )
    else
      cable_ready[ListsChannel].morph(
        selector: '#lists-create-form',
        focus_selector: "#{dom_id(@list)} .task-name-input",
        html: render_to_string(partial: 'lists/create_form', locals: { list: @list })
      )
    end

    cable_ready.broadcast_to current_user
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end
end
