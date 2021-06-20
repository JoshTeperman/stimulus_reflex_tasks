class AddPositionToTask < ActiveRecord::Migration[6.0]
  def change
    add_column :tasks, :position, :integer, null: false
  end
end
