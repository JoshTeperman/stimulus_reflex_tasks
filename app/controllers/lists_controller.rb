class ListsController < ApplicationController
  include CableReady::Broadcaster

  def index
    @lists = List.all
    @new_task ||= Task.new
  end

  def new
    list = List.new
    cable_ready[ListsChannel].insert_adjacent_html(
      selector: '#lists',
      focus_selector: "#list-create-form-#{list.client_id} .list-name-input",
      html: render_to_string(partial: 'lists/create_form', locals: { list: list })
    )
    cable_ready.broadcast_to current_user
  end

  def create
    @list = List.new(list_params.merge(team: current_user.team))

    if @list.save
      cable_ready[ListsChannel].remove(
        selector: "#list-create-form-#{params.dig('list', 'client_id')}"
      ).broadcast_to current_user

      cable_ready[TeamChannel].insert_adjacent_html(
        selector: '#lists',
        html: render_to_string(@list, assigns: { new_task: Task.new })
      ).broadcast_to current_user.team
    else
      cable_ready[ListsChannel].morph(
        selector: "#list-create-form-#{params.dig('list', 'client_id')}",
        focus_selector: "#{dom_id(@list)} .task-name-input",
        html: render_to_string(partial: 'lists/create_form', locals: { list: @list })
      ).broadcast_to current_user
    end
  end

  def destroy
    @list = List.find_by(id: params[:id])
    @list.destroy!

    cable_ready[TeamChannel].remove(
      selector: dom_id(@list)
    )

    cable_ready.broadcast_to current_user.team
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end
end
