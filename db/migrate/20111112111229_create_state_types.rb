class CreateStateTypes < ActiveRecord::Migration
  def change
    create_table :state_types do |t|
      t.string :code

      t.timestamps
    end
  end
end
