class CreateProjectTypes < ActiveRecord::Migration
	def change
		create_table :project_types do |t|
			t.string :code

			t.timestamps
		end
	end
end
