class CreatePriorityTypes < ActiveRecord::Migration
  def change
    create_table :priority_types do |t|
      t.string :code
      t.integer :value

      t.timestamps
    end
  end
end
