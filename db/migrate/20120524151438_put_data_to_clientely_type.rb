class PutDataToClientelyType < ActiveRecord::Migration
  def up
		ClientelyType.create(
			:code => "none"
		)
		ClientelyType.create(
			:code => "order"
		)
		ClientelyType.create(
			:code => "adaptation"
		)
		ClientelyType.create(
			:code => "moreover"
		)
  end

  def down
  end
end
