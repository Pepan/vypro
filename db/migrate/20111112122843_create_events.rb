class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.references :origin_type
      t.references :user
      t.string :target_class
      t.boolean :viewed
      t.integer :data_id

      t.timestamps
    end
    add_index :events, :origin_type_id
    add_index :events, :user_id
  end
end
