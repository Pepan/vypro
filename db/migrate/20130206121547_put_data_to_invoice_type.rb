class PutDataToInvoiceType < ActiveRecord::Migration
  def up
	  InvoiceType.create(
		  :code => 'income'
	  )
	  InvoiceType.create(
		  :code => 'issue'
	  )
  end

  def down
  end
end
