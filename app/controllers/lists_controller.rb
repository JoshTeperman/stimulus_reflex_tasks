class ListsController < ApplicationController
  include CableReady::Broadcaster
  after_action :broadcast_to_current_user, only: %i[new create destroy]

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
  end

  def create
    @list = List.new(list_params)

    if @list.save
      cable_ready[ListsChannel].replace(
        selector: "#list-create-form-#{params.dig('list', 'client_id')}",
        focus_selector: "#{dom_id(@list)} .task-name-input",
        html: render_to_string(@list, assigns: { new_task: Task.new })
      )
    else
      cable_ready[ListsChannel].morph(
        selector: "#list-create-form-#{params.dig('list', 'client_id')}",
        focus_selector: "#{dom_id(@list)} .task-name-input",
        html: render_to_string(partial: 'lists/create_form', locals: { list: @list })
      )
    end
  end

  def destroy
    @list = List.find_by(id: params[:id])
    @list.destroy!

    cable_ready[ListsChannel].remove(
      selector: dom_id(@list)
    )
  end

  private

  def list_params
    params.require(:list).permit(:name)
  end

  def broadcast_to_current_user
    cable_ready.broadcast_to current_user
  end
end
