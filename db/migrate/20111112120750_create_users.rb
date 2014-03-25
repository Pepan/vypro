class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :firstname
      t.string :lastname
      t.references :company

      t.timestamps
    end
    add_index :users, :company_id
  end
end
