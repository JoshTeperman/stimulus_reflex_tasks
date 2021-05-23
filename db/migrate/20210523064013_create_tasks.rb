class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :name, null: false
      t.references :list, null: false, foreign_key: true
      t.datetime :completed_at

      t.timestamps
    end
  end
end
