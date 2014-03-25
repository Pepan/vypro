class CreateRelationTypes < ActiveRecord::Migration
  def change
    create_table :relation_types do |t|
      t.string :code

      t.timestamps
    end
  end
end
