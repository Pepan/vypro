class AddByUserIdToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :by_user_id, :integer
  end
end
