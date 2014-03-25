class AddAbbrovedByToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :approved_by_user_id, :integer
  end
end
