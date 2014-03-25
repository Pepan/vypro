class AddIndexesToSpeedUp < ActiveRecord::Migration
  def change
	  add_index :tasks, :sprint_id
	  
	  add_index :events, :action_type_id
	  add_index :events, :project_id
	  
	  add_index :action_types, :code
	  #add_index :action_types, :created_at
  end
end
