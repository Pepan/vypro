class PutDataToProjectStateType < ActiveRecord::Migration
	def up
		ProjectStateType.create(
			:code => "preparation"
		)
		ProjectStateType.create(
			:code => "inprogress"
		)
		ProjectStateType.create(
			:code => "completed"
		)
		ProjectStateType.create(
			:code => "blocked"
		)
		ProjectStateType.create(
			:code => "aborted"
		)
	end

	def down
	end
end
