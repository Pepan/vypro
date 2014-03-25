class PutDataToDurationType < ActiveRecord::Migration
	def up
		DurationType.create(
			:code => "30mins",
			:duration => 30
		)
		DurationType.create(
			:code => "1hour",
			:duration => 1*60
		)
		DurationType.create(
			:code => "2hours",
			:duration => 2*60
		)
		DurationType.create(
			:code => "3hours",
			:duration => 3*60
		)
		DurationType.create(
			:code => "4hours",
			:duration => 4*60
		)
		DurationType.create(
			:code => "1day",
			:duration => 1*6*60
		)
		DurationType.create(
			:code => "2days",
			:duration => 2*6*60
		)
		DurationType.create(
			:code => "3days",
			:duration => 3*6*60
		)
		DurationType.create(
			:code => "4days",
			:duration => 4*6*60
		)
		DurationType.create(
			:code => "1week",
			:duration => 5*6*60
		)
		DurationType.create(
			:code => "2weeks",
			:duration => 10*6*60
		)
	end

	def down
	end
end
