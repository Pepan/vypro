class ProjectUserRelationsController < ApplicationController
	load_and_authorize_resource
	before_filter :set_title, :only => [:show, :edit]
	
	# GET /project_user_relations
	# GET /project_user_relations.json
	def index
		@user_relation = ProjectUserRelation.new({project_id: params[:project_id]})
		@project = @user_relation.project
		@user_relations = @project.project_user_relations
		authorize! :read, @project
		
		make_breadcrumbs

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @user_relations }
		end
	end

	# GET /project_user_relations/1
	# GET /project_user_relations/1.json
	def show
		listable_actions = ActionType.where(:code=>['create', 'update', 'destroy', 'approve'])

		@user_relation = ProjectUserRelation.find(params[:id])
		#puts '1. '+@user_relation.inspect
		@project = @user_relation.project
		@user = @user_relation.user;
		@user.current_project = @user_relation.project
		@tasks = @user.tasks_for(@user_relation.project).includes(:efforts).includes(:task_type).includes(:state_type).includes(:clientely_type).includes(:assigned_user)
		@events = @user.events.by_project(@project).where(:action_type_id => listable_actions).includes(:action_type).limit 8

		make_breadcrumbs

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @user_relation }
		end
	end

	# GET /project_user_relations/new
	# GET /project_user_relations/new.json
	def new
		@user_relation = ProjectUserRelation.new({project_id: params[:project_id]})
		make_breadcrumbs

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @user_relation }
		end
	end

	# GET /project_user_relations/1/edit
	def edit
		@user_relation = ProjectUserRelation.find(params[:id])
		make_breadcrumbs
	end

	# POST /project_user_relations
	# POST /project_user_relations.json
	def create
		@user_relation = ProjectUserRelation.new(params[:project_user_relation].merge({project_id: params[:project_id]}))
		make_breadcrumbs

		respond_to do |format|
			if @user_relation.save
				format.html { redirect_to project_user_relations_path(@user_relation.project_id), notice: t('app.projects.users.relations.created') }
				format.json { render json: @user_relation, status: :created, location: @user_relation }
			else
				format.html { render action: "new" }
				format.json { render json: @user_relation.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /project_user_relations/1
	# PUT /project_user_relations/1.json
	def update
		@user_relation = ProjectUserRelation.find(params[:id])
		make_breadcrumbs

		respond_to do |format|
			if @user_relation.update_attributes(params[:project_user_relation])
				format.html { redirect_to project_user_relation_path(@user_relation.project_id, @user_relation.id), notice: t('app.projects.users.relations.updated') }
				format.json { head :ok }
			else
				format.html { render action: "edit" }
				format.json { render json: @user_relation.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /project_user_relations/1
	# DELETE /project_user_relations/1.json
	def destroy
		@user_relation = ProjectUserRelation.find(params[:id])
		@user_relation.destroy

		respond_to do |format|
			format.html { redirect_to project_user_relations_url(@user_relation.project_id) }
			format.json { head :ok }
		end
	end

	private
	def make_breadcrumbs
		@project_user_relation = @user_relation
		idparent = 'project';
		idname = 'project_user_relation';
		
		case self.action_name
		when 'index' then
			breadcrumbs.add t("page.title.#{idparent.pluralize}.show")+' '+eval("@#{idname}.#{idparent}.name"), eval("#{idparent}_path @#{idname}.#{idparent}_id")
			breadcrumbs.add t("page.title.#{idname.pluralize}.index")
		when 'new','create' then
			breadcrumbs.add t("page.title.#{idparent.pluralize}.show")+' '+eval("@#{idname}.#{idparent}.name"), eval("#{idparent}_path @#{idname}.#{idparent}_id")
			breadcrumbs.add t("page.title.#{idname.pluralize}.new")
		when 'show' then
			breadcrumbs.add t("page.title.#{idparent.pluralize}.show")+' '+eval("@#{idname}.#{idparent}.name"), eval("#{idparent}_path @#{idname}.#{idparent}_id")
			breadcrumbs.add eval("@#{idname}.user.full_name")
		when 'edit', 'update' then
			breadcrumbs.add t("page.title.#{idparent.pluralize}.show")+' '+eval("@#{idname}.#{idparent}.name"), eval("#{idparent}_path @#{idname}.#{idparent}_id")
			breadcrumbs.add t("page.title.#{idname.pluralize}.edit")+' '+eval("@#{idname}.user.full_name")
		else
			# nic
		end
	end
	
	def set_title
		# ono se to bere z toho load_and_authorize_resource
		puts '2. '+@project_user_relation.inspect
		@title = @project_user_relation.user.full_name+' - '+@project_user_relation.project.name unless (@project_user_relation.nil? or @project_user_relation.user.nil?)
	end
end
