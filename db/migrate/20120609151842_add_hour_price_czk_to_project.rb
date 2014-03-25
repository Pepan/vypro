class AddHourPriceCzkToProject < ActiveRecord::Migration
  def change
    add_column :projects, :hour_price_czk, :integer
  end
end
