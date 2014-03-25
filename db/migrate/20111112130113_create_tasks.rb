class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.references :project
      t.references :task_type
      t.references :user
      t.references :state_type

      t.timestamps
    end
    add_index :tasks, :project_id
    add_index :tasks, :task_type_id
    add_index :tasks, :user_id
    add_index :tasks, :state_type_id
  end
end
