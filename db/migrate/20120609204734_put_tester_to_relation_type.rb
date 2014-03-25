class PutTesterToRelationType < ActiveRecord::Migration
  def up
		RelationType.create(
			:code => "tester"
		)
  end

  def down
  end
end
