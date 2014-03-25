module UsersHelper
	def company_select(f)
		if @user.company.nil?
			f.select :company_id, Company.all.collect {|p| [p.name, p.id ]}, {:include_blank => false, :prompt => t("helpers.select.prompt")}
		else
			render :partial => "companies/view_for_edit", :locals => { :f => f, :company => @user.company }
		end
	end

	def user_parent_name
		# (not @project.nil? ? @project.t_name : '') + (not @company.nil? ? @company.name : '')
		return @project.t_name unless @project.nil?
		return @company.name unless @company.nil?
	end

	def parent_user_path(user)
		return project_user_path(@project, user) unless @project.nil?
		return company_user_path(@company, user) unless @company.nil?
	end
end
