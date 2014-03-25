class CreateProjectStateTypes < ActiveRecord::Migration
  def change
    create_table :project_state_types do |t|
      t.string :code

      t.timestamps
    end
  end
end
