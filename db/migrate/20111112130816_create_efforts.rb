class CreateEfforts < ActiveRecord::Migration
  def change
    create_table :efforts do |t|
      t.string :name
      t.string :description
      t.integer :progress
      t.datetime :begin_at
      t.datetime :end_at
      t.references :user
      t.references :task

      t.timestamps
    end
    add_index :efforts, :user_id
    add_index :efforts, :task_id
  end
end
