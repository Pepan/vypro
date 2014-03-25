class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.string :number
      t.integer :sum_czk
      t.references :invoice_type
      t.references :project_user_relation

      t.timestamps
    end
    add_index :invoices, :invoice_type_id
    add_index :invoices, :project_user_relation_id
  end
end
