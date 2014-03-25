class ProjectType < ActiveRecord::Base
	attr_accessible :code

	validates :code, :presence => true
	validates_uniqueness_of :code

	def t_name
		I18n.t('app.projects.type.'+code)
	end
	alias_method :to_s, :t_name

	def fix?
		self.code == 'fix'
	end

	def agile?
		self.code == 'agile'
	end
end
