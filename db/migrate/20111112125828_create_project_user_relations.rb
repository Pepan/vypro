class CreateProjectUserRelations < ActiveRecord::Migration
  def change
    create_table :project_user_relations do |t|
      t.references :project
      t.references :user
      t.references :relation_type

      t.timestamps
    end
    add_index :project_user_relations, :project_id
    add_index :project_user_relations, :user_id
    add_index :project_user_relations, :relation_type_id
  end
end
