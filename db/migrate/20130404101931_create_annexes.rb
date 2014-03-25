class CreateAnnexes < ActiveRecord::Migration
  def change
    create_table :annexes do |t|
      t.string :name
      t.string :source
      t.string :ext
      t.integer :size
      t.references :task
      t.references :user

      t.timestamps
    end
    add_index :annexes, :task_id
    add_index :annexes, :user_id
  end
end
