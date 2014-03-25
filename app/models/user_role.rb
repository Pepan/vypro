class UserRole < ActiveRecord::Base
	attr_accessible :code
	
	validates :code, :presence => true
	validates_uniqueness_of :code

	def t_name
		I18n.t("app.user_roles."+code)
	end
end
