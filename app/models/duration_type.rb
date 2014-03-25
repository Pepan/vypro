class DurationType < ActiveRecord::Base
	attr_accessible :code, :duration
	
	validates :code, :duration, :presence => true
	validates_uniqueness_of :code

	def t_name
		I18n.t("app.projects.tasks.durations."+code)
	end
end
