class AddHourPriceCzkToProjectUserRelation < ActiveRecord::Migration
  def change
	  add_column :project_user_relations, :hour_price_czk, :integer
  end
end
