# encoding: utf-8

class ApplicationController < ActionController::Base
	protect_from_forgery

	before_filter :set_initials
	before_filter :authenticate_user!

	after_filter :save_event

	rescue_from CanCan::AccessDenied do |exception|
		redirect_to root_url, :alert => exception.message
	end
  
	def after_sign_in_path_for(resource)
		if resource.is_a?(User)
			root_url
		else
			super
		end
	end	
	
	private
		def set_initials
			breadcrumbs.add t('page.navig.home'), root_path
			begin
				present_user.current_project = Project.find(params[:project_id]) unless params[:project_id].nil?
				present_user.current_project ||= Project.find(params[:id]) if !params[:id].nil? and self.controller_name == 'projects'
			rescue Exception => e
				puts e.message
			end
		end
		
		def save_event
			class_name = self.controller_name.singularize.capitalize
			if eval("defined?(#{class_name}) && #{class_name}.is_a?(Class)")
				
				data_id = params[:id] unless params[:id].nil?
				last_model = eval(class_name).last if ['create'].include? self.action_name
				data_id = last_model.id unless last_model.nil?
				
				project_id = params[:project_id] unless params[:project_id].nil?
				ActionType.create({:code => self.action_name}) unless ActionType.exists?(:code => self.action_name)

				Event.create({
						:user_id => present_user.id, 
						:data_id => data_id, 
						:viewed => false, 
						:target_class => self.controller_name,
						:project_id => project_id,
						:action_type_id => ActionType.find_by_code(self.action_name).id
				})			
			end
		end
	
	# By default, all the helpers are available in the views but not in the controllers.
	include SessionHelper
end
