class Event < ActiveRecord::Base
	belongs_to :action_type
	belongs_to :origin_type
	belongs_to :user
	belongs_to :project
  
	default_scope order('events.id DESC')

	def self.by_project(project)
		where(project_id: project.id)
	end

	def t_name
		I18n.t('activerecord.models.'+self.target_class.singularize)
	end

	def originator_model
		@originator_model ||= eval(self.target_class.singularize.capitalize)
	end
	
	def data_exists?
		@data_exists ||= originator_model.exists?(self.data_id)
	end
	
	def data
		@data ||= originator_model.find(self.data_id)
	end
	
	def originator_name
		@originator_name ||= data.name if originator_model.respond_to? :name and !self.data_id.nil? and data_exists?
	end
end
