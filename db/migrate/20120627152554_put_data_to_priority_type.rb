class PutDataToPriorityType < ActiveRecord::Migration
  def up
		PriorityType.create!(
			:code => "low",
			:value => 1
		)
		PriorityType.create!(
			:code => "medium",
			:value => 2
		)
		PriorityType.create!(
			:code => "high",
			:value => 3
		)
		PriorityType.create!(
			:code => "urgent",
			:value => 4
		)
  end

  def down
  end
end
