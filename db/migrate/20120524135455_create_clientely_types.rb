class CreateClientelyTypes < ActiveRecord::Migration
  def change
    create_table :clientely_types do |t|
      t.string :code

      t.timestamps
    end
  end
end
