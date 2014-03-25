class AddActionTypeToEvent < ActiveRecord::Migration
  def change
    add_column :events, :action_type, :integer
  end
end
