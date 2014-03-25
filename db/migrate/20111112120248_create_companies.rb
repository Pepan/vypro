class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.text :description
      t.text :address
      t.string :idnumber

      t.timestamps
    end
  end
end
