class AddStateToProject < ActiveRecord::Migration
  def change
    add_column :projects, :project_state_type_id, :integer
  end
end
