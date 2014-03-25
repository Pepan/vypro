class PageController < ApplicationController
	skip_before_filter :authenticate_user!

	def home
		if user_signed_in?
			listable_actions = ActionType.where(:code=>['create', 'update', 'destroy', 'approve'])
			@tasks = present_user.active_tasks.limit 5
			@events = present_user.events.where(:action_type_id => listable_actions).limit 10
			@projects = present_user.projects
		else
			@demo_accounts = []
			User.all.each do |user|
				@demo_accounts << user.email if user.firstname == 'Tester'
			end
		end

	end

	def help
	end

	private
	def set_title
		@title = t("page.title." + action_name)
		@description = t("page.desc." + action_name)
	end
	def select_layout
		return 'old_browsers' if request.user_agent.include? 'MSIE 6'
		"application"
	end
  
end
