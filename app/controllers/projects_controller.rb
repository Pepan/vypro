class ProjectsController < ApplicationController
	load_and_authorize_resource
	before_filter :set_title, :only => [:new, :show, :edit]
	
	# GET /projects
	# GET /projects.json
	def index
		if present_user.role? 'admin'
			@projects = Project.all
		else
			@projects = present_user.projects
		end
		make_breadcrumbs

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @projects }
		end
	end

	# GET /projects/1
	# GET /projects/1.json
	def show
		listable_actions = ActionType.where(:code=>['create', 'update', 'destroy', 'approve'])

		@project = Project.find(params[:id])
		@tasks = @project.root_tasks
		@events = @project.events.where(:action_type_id => listable_actions).limit 6
		@sprints = @project.sprints
		@user_relations = @project.project_user_relations

		make_breadcrumbs
		session[:last_controler] = self.controller_name

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @project }
		end
	end

	# GET /projects/new
	# GET /projects/new.json
	def new
		@project = Project.new({:project_state_type_id => ProjectStateType.find_by_code('preparation').id})
		puts @project.inspect
		make_breadcrumbs
		
		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @project }
		end
	end

	# GET /projects/1/edit
	def edit
		@project = Project.find(params[:id])
		make_breadcrumbs
	end

	# POST /projects
	# POST /projects.json
	def create
		@project = Project.new(params[:project].merge({:user_id => present_user.id}))
		make_breadcrumbs

		respond_to do |format|
			if @project.save
				format.html { redirect_to @project, notice: t('app.projects.created') }
				format.json { render json: @project, status: :created, location: @project }
			else
				format.html { render action: "new" }
				format.json { render json: @project.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /projects/1
	# PUT /projects/1.json
	def update
		@project = Project.find(params[:id])
		make_breadcrumbs
		
		respond_to do |format|
			if @project.update_attributes(params[:project])
				format.html { redirect_to @project, notice: t('app.projects.updated') }
				format.json { head :ok }
			else
				format.html { render action: "edit" }
				format.json { render json: @project.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /projects/1
	# DELETE /projects/1.json
	def destroy
		@project = Project.find(params[:id])
		@project.destroy

		respond_to do |format|
			format.html { redirect_to projects_url }
			format.json { head :ok }
		end
	end

	# PUT /sprints/add
	def duplicate
		@project = Project.find(params[:id])

		respond_to do |format|
			new_project = @project.duplicate!
			if new_project
				format.html { redirect_to project_path(new_project.id), notice: t('app.projects.duplicated') }
			else
				format.html { render action: "show" }
			end
		end
	end

	private
	def make_breadcrumbs
		idname = 'project';
		
		case self.action_name
		when 'index' then
			breadcrumbs.add t("page.title.#{idname.pluralize}.index")
		when 'new','create' then
			breadcrumbs.add t("page.title.#{idname.pluralize}.index"), eval("#{idname.pluralize}_path")
			breadcrumbs.add t("page.title.#{idname.pluralize}.new")
		when 'show' then
			breadcrumbs.add t("page.title.#{idname.pluralize}.index"), eval("#{idname.pluralize}_path")
			breadcrumbs.add eval("@#{idname}.name")
		when 'edit', 'update' then
			breadcrumbs.add t("page.title.#{idname.pluralize}.index"), eval("#{idname.pluralize}_path")
			breadcrumbs.add t("page.title.#{idname.pluralize}.edit")+' '+eval("@#{idname}.name")
		else
			# nic
		end
	end
	
	def set_title
		@title = @project.name unless @project.nil?
	end
end
