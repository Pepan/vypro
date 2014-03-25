class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.text :content
      t.references :user
      t.references :task

      t.timestamps
    end
    add_index :notes, :user_id
    add_index :notes, :task_id
  end
end
