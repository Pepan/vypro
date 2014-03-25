class CreateDurationTypes < ActiveRecord::Migration
  def change
    create_table :duration_types do |t|
      t.string :code
      t.integer :duration

      t.timestamps
    end
  end
end
