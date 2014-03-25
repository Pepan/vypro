class CreateSprints < ActiveRecord::Migration
  def change
    create_table :sprints do |t|
      t.string :name
      t.integer :tier
      t.references :project

      t.timestamps
    end
    add_index :sprints, :project_id
  end
end
