class PriorityType < ActiveRecord::Base
	attr_accessible :code, :value
  
	def t_name
		I18n.t("app.projects.tasks.priority.type."+code)
	end
	
	def symbol
		I18n.t("app.projects.tasks.priority.symbol."+code)
	end
end
