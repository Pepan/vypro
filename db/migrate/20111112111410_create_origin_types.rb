class CreateOriginTypes < ActiveRecord::Migration
  def change
    create_table :origin_types do |t|
      t.string :code

      t.timestamps
    end
  end
end
