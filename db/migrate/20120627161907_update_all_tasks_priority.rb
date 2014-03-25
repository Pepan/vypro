class UpdateAllTasksPriority < ActiveRecord::Migration
  def up
	  priority = PriorityType.find_by_code 'medium'
	  Task.where(:priority_type_id=>nil).update_all(:priority_type_id => priority.id)
  end

  def down
  end
end
