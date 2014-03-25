class TasksController < ApplicationController
	load_and_authorize_resource
	before_filter :set_title, :only => [:new, :show, :edit]
	
	# GET /tasks
	# GET /tasks.json
	def index
		if params[:task_id].nil?
			@task = Task.new({project_id: params[:project_id], :user_id => present_user.id, :state_type_id => StateType.find_by_code('new').id})
			@project = @task.project
			@tasks = @project.root_tasks
			authorize! :read, @project
		else
			@task = Task.new({project_id: params[:project_id], :user_id => present_user.id, :state_type_id => StateType.find_by_code('new').id})
			@tasks = @task.tasks
			authorize! :read, @task
		end
		
		make_breadcrumbs

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @tasks }
			format.csv
		end
	end

	# GET /tasks/1
	# GET /tasks/1.json
	def show
		@task = Task.find(params[:id])
		@project = @task.project
		@tasks = @task.tasks
		@efforts = @task.efforts
		@notes = @task.notes
		@annexes = @task.annexes

		@worth = {}
		@worth[:user] = @task.worth(@task.assigned_user.relation_to(@task.project).hour_price_czk)
		@worth[:project] = @task.worth(@task.project.hour_price_czk)
		@worth[:profit] = @worth[:project] - @worth[:user]

		make_breadcrumbs
		session[:last_controler] = self.controller_name

		unless @task.project.tasks.empty?
			index = @task.project.tasks.index(@task)
			@tprev = @task.project.tasks[index-1] if index-1 >= 0
			@tnext = @task.project.tasks[index+1]
		end
		
		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @task }
		end
	end

	# GET /tasks/new
	# GET /tasks/new.json
	def new
		@last_task = Task.where(project_id: params[:project_id]).order("created_at DESC").first
		@task = Task.new(
			:project_id => params[:project_id], 
			:user_id => present_user.id, 
			:state_type_id => StateType.find_by_code('new').id,
			:task_type_id => (params[:type].nil? ? nil : TaskType.find_by_code(params[:type]).id),
			:task_id => params[:task_id],
			:assigned_user_id => (@last_task.nil? ? nil : @last_task.assigned_user_id),
			:clientely_type_id => (!@last_task.nil? and !@last_task.project.work_started_at.nil? and @last_task.project.work_started_at > Time.now ? ClientelyType.find_by_code('order').id : @last_task.clientely_type_id),
			:priority_type_id => (@last_task.nil? ? nil : @last_task.priority_type_id),
			:sprint_id => (@last_task.nil? ? nil : @last_task.sprint_id)
		)
		make_breadcrumbs

		respond_to do |format|
			if @task.project.users.any?
				format.html # new.html.erb
				format.json { render json: @task }
			else
				format.html { redirect_to by_session_path, alert: t('app.projects.tasks.users_missing') }
				format.json { render json: @task.errors, status: :unprocessable_entity }
			end
		end
	end

	# GET /tasks/1/edit
	def edit
		@task = Task.find(params[:id])
		make_breadcrumbs
	end

	# POST /tasks
	# POST /tasks.json
	def create
		@task = Task.new(
			params[:task].merge({
					:project_id => params[:project_id], 
					:user_id => present_user.id, 
					:state_type_id => StateType.find_by_code('new').id,
					:task_id => params[:task][:task_id]
			})
		)

		make_breadcrumbs

		respond_to do |format|
			if @task.save
				TaskMailer.new_task(@task).deliver if @task.project.project_state_type.code == 'inprogress'

				format.html { redirect_to by_session_path, notice: t('app.projects.tasks.created') }
				format.json { render json: @task, status: :created, location: @task }
			else
				format.html { render action: "new" }
				format.json { render json: @task.errors, status: :unprocessable_entity }
			end
		end
		session[:last_controler] = nil
	end

	# PUT /tasks/1
	# PUT /tasks/1.json
	def update
		@task = Task.find(params[:id])
		make_breadcrumbs

		respond_to do |format|
			if @task.update_attributes(params[:task])
				format.html { redirect_to by_session_path, notice: t('app.projects.tasks.updated') }
				format.json { head :ok }
			else
				#puts @task.errors.inspect
				format.html { render action: "edit" }
				format.json { render json: @task.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /tasks/1
	# DELETE /tasks/1.json
	def destroy
		@task = Task.find(params[:id])
		@task.destroy

		respond_to do |format|
			format.html { redirect_to project_url(@task.project_id) }
			format.json { head :ok }
		end
	end
	
	def approve
		@task = Task.find(params[:id])
		make_breadcrumbs

		respond_to do |format|
			if @task.update_attributes(state_type_id: StateType.find_by_code('approved').id, approved_by_user_id: present_user.id)
				format.html { redirect_to project_path(@task.project_id), notice: t('app.projects.tasks.approved') }
				format.json { head :ok }
			else
				format.html { render action: "edit" }
				format.json { render json: @task.errors, status: :unprocessable_entity }
			end
		end
	end

	def tree
		@project = Project.find(params[:project_id])
		@tasks = @project.root_tasks.includes(:efforts).includes(:task_type).includes(:state_type).includes(:clientely_type).includes(:assigned_user)
		
		respond_to do |format|
			format.js
		end
	end
	
	def moreover
		@project = Project.find(params[:project_id])
		@tasks = @project.tasks.by_clientely(ClientelyType.find_by_code('moreover')).reorder('created_at ASC') 
		make_breadcrumbs
		
		respond_to do |format|
			format.html
		end
	end
	
	def younger
		@task = Task.new({project_id: params[:project_id], :user_id => present_user.id, :state_type_id => StateType.find_by_code('new').id, :task_type_id => TaskType.find_by_code('bug').id})
		@project = Project.find(params[:project_id])
		@tasks = @project.tasks.younger_than(@project.work_started_at).reorder('created_at ASC') 
		make_breadcrumbs
		
		respond_to do |format|
			format.html
		end
	end
	
	private
	def make_breadcrumbs
		idparent = 'project';
		idname = 'task';
		
		case self.action_name
		when 'index', 'younger' then
			breadcrumbs.add t("page.title.#{idparent.pluralize}.show")+' '+eval("@#{idname}.#{idparent}.name"), eval("#{idparent}_path @#{idname}.#{idparent}_id")
			breadcrumbs.add t("page.title.#{idname.pluralize}.index")
		when 'new','create' then
			breadcrumbs.add t("page.title.#{idparent.pluralize}.show")+' '+eval("@#{idname}.#{idparent}.name"), eval("#{idparent}_path @#{idname}.#{idparent}_id")
			breadcrumbs.add t("page.title.#{idname.pluralize}.show")+' '+eval("@#{idname}.#{idname}.name"), eval("#{idparent}_#{idname}_path @#{idname}.#{idparent}_id, @#{idname}.#{idname}_id") unless eval("@#{idname}.#{idname}_id").nil?
			breadcrumbs.add t("page.title.#{idname.pluralize}.new")
		when 'show' then
			breadcrumbs.add t("page.title.#{idparent.pluralize}.show")+' '+eval("@#{idname}.#{idparent}.name"), eval("#{idparent}_path @#{idname}.#{idparent}_id")
			breadcrumbs.add t("page.title.#{idname.pluralize}.show")+' '+eval("@#{idname}.#{idname}.name"), eval("#{idparent}_#{idname}_path @#{idname}.#{idparent}_id, @#{idname}.#{idname}_id") unless eval("@#{idname}.#{idname}_id").nil?
			breadcrumbs.add t("page.title.#{idname.pluralize}.show")+' '+eval("@#{idname}.name")
		when 'edit', 'update' then
			breadcrumbs.add t("page.title.#{idparent.pluralize}.show")+' '+eval("@#{idname}.#{idparent}.name"), eval("#{idparent}_path @#{idname}.#{idparent}_id")
			breadcrumbs.add t("page.title.#{idname.pluralize}.show")+' '+eval("@#{idname}.#{idname}.name"), eval("#{idparent}_#{idname}_path @#{idname}.#{idparent}_id, @#{idname}.#{idname}_id") unless eval("@#{idname}.#{idname}_id").nil?
			breadcrumbs.add t("page.title.#{idname.pluralize}.edit")+' '+eval("@#{idname}.name")
		else
			# nic
		end
	end
	
	def by_session_path
		if ['create'].include? self.action_name
			((session[:last_controler]=='projects' or @task.task_id.nil?) ? project_path(@task.project_id) : project_task_path(@task.project_id, @task.task_id))
		else
			project_task_path(@task.project_id, @task.id)
		end
	end
	
	def set_title
		@task.project_id ||= params[:project_id] unless @task.nil?
		@title = (@task.name.nil? ? '' : @task.name+' - ')+@task.project.name unless @task.nil?
	end
end
