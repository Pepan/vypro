class ClientelyType < ActiveRecord::Base
	attr_accessible :code
	
	validates :code, :presence => true
	validates_uniqueness_of :code

	def t_name
		I18n.t("app.projects.tasks.clientely.type."+code)
	end
end
