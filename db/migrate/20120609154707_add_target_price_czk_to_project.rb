class AddTargetPriceCzkToProject < ActiveRecord::Migration
  def change
    add_column :projects, :target_price_czk, :integer
  end
end
