class AddTaskAndSprintToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :task_id, :integer
    add_column :tasks, :sprint_id, :integer
  end
end
