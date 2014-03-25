class PutDataToProjectTypes < ActiveRecord::Migration
	def up
		ProjectType.create(
			:code => 'fix'
		)
		ProjectType.create(
			:code => 'agile'
		)
	end

	def down
	end
end
