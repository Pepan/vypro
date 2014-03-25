class SetDefaultProjectState < ActiveRecord::Migration
	def up
		state = ProjectStateType.find_by_code('preparation')
		Project.all.each do |project|
			project.project_state_type_id = state.id
			project.save
		end
	end

	def down
	end
end
