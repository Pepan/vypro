class SprintsController < ApplicationController
	load_and_authorize_resource
	before_filter :set_title, :only => [:new, :show, :edit]

	# GET /sprints
	# GET /sprints.json
	def index
		unless params[:project_id].nil?
			@sprint = Sprint.new( {project_id: params[:project_id]} )
			@project = @sprint.project
			@sprints = @project.events.where(:action_type_id => listable_actions)
			#authorize! :read, @project
			make_breadcrumbs
		else
			@sprints = Sprint.all
		end
		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @sprints }
		end
	end

	# GET /sprints/1
	# GET /sprints/1.json
	def show
		listable_actions = ActionType.where(:code=>['create', 'update', 'destroy', 'approve'])
		
		@sprint = Sprint.find(params[:id])
		@tasks = @sprint.tasks
		@events = @sprint.events.where(:action_type_id => listable_actions).limit 10

		make_breadcrumbs

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @sprint }
		end
	end

	# GET /sprints/new
	# GET /sprints/new.json
	def new
		@sprint = Sprint.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @sprint }
		end
	end

	# GET /sprints/1/edit
	def edit
		@sprint = Sprint.find(params[:id])
	end

	# POST /sprints
	# POST /sprints.json
	def create
		@sprint = Sprint.new(params[:sprint])

		respond_to do |format|
			if @sprint.save
				format.html { redirect_to @sprint, notice: t('app.projects.sprints.created') }
				format.json { render json: @sprint, status: :created, location: @sprint }
			else
				format.html { render action: "new" }
				format.json { render json: @sprint.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /sprints/1
	# PUT /sprints/1.json
	def update
		@sprint = Sprint.find(params[:id])

		respond_to do |format|
			if @sprint.update_attributes(params[:sprint])
				format.html { redirect_to @sprint, notice: t('app.projects.sprints.updated') }
				format.json { head :ok }
			else
				format.html { render action: "edit" }
				format.json { render json: @sprint.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /sprints/1
	# DELETE /sprints/1.json
	def destroy
		@sprint = Sprint.find(params[:id])
		@sprint.destroy

		respond_to do |format|
			format.html { redirect_to sprints_url }
			format.json { head :ok }
		end
	end

	# PUT /sprints/add
	# PUT /sprints/add.json
	def add
		@sprint = Sprint.new( {project_id: params[:project_id]} )

		respond_to do |format|
			if @sprint.save
				format.html { redirect_to project_path(@sprint.project_id), notice: t('app.projects.sprints.created') }
				format.json { render json: @sprint, status: :created, location: @sprint }
			else
				format.html { render action: "new" }
				format.json { render json: @sprint.errors, status: :unprocessable_entity }
			end
		end
	end
		
	private
	def make_breadcrumbs
		idparent = 'project';
		idname = 'sprint';
		
		case self.action_name
		when 'index' then
			breadcrumbs.add t("page.title.#{idparent.pluralize}.show")+' '+eval("@#{idname}.#{idparent}.name"), eval("#{idparent}_path @#{idname}.#{idparent}_id")
			breadcrumbs.add t("page.title.#{idname.pluralize}.index")
		when 'new','create' then
			breadcrumbs.add t("page.title.#{idparent.pluralize}.show")+' '+eval("@#{idname}.#{idparent}.name"), eval("#{idparent}_path @#{idname}.#{idparent}_id")
			breadcrumbs.add t("page.title.#{idname.pluralize}.new")
		when 'show' then
			breadcrumbs.add t("page.title.#{idparent.pluralize}.show")+' '+eval("@#{idname}.#{idparent}.name"), eval("#{idparent}_path @#{idname}.#{idparent}_id")
			breadcrumbs.add t("page.title.#{idname.pluralize}.show")+' '+eval("@#{idname}.tier.to_s")+'.'
		when 'edit', 'update' then
			breadcrumbs.add t("page.title.#{idparent.pluralize}.show")+' '+eval("@#{idname}.#{idparent}.name"), eval("#{idparent}_path @#{idname}.#{idparent}_id")
			breadcrumbs.add t("page.title.#{idname.pluralize}.edit")+' '+eval("@#{idname}.tier.to_s")+'.'
		else
			# nic
		end
	end
	
	# use projects helper methods
	include ProjectsHelper
	
	def set_title
		@sprint.project_id ||= params[:project_id]
		@title = @sprint.tier.to_s+'. '+@sprint.project.name unless @sprint.nil?
	end
end
