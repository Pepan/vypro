class PutIdeaToTaskTypes < ActiveRecord::Migration
  def up
		TaskType.create!(
			:code => "idea"
		)
  end

  def down
  end
end
