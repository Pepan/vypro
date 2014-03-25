class RenameActionTypeAtEvent < ActiveRecord::Migration
	def change
		rename_column :events, :action_type, :action_type_id
	end
end
