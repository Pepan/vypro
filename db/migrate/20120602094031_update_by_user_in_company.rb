class UpdateByUserInCompany < ActiveRecord::Migration
  def up
	  user = User.find_by_lastname 'Chmel'
	  Company.update_all :by_user_id => user.id unless user.nil?
  end

  def down
  end
end
