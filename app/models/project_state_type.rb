class ProjectStateType < ActiveRecord::Base
	attr_accessible :code
	
	validates :code, :presence => true
	validates_uniqueness_of :code

	def t_name
		I18n.t("app.projects.state.type."+code)
	end
end
