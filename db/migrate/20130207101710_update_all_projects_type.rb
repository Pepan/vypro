class UpdateAllProjectsType < ActiveRecord::Migration
	def up
		type = ProjectType.find_by_code 'fix'
		Project.where(:project_type_id=>nil).update_all(:project_type_id => type.id)
	end

	def down
	end
end
