class AddPriorityTypeToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :priority_type_id, :integer
  end
end
