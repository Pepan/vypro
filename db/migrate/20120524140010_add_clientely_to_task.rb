class AddClientelyToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :clientely_type_id, :integer
  end
end
