class EffortsController < ApplicationController
	load_and_authorize_resource
	before_filter :set_title, :only => [:new, :show, :edit]

	# GET /efforts
	# GET /efforts.json
	def index
		@effort = Effort.new({task_id: params[:task_id], user_id: present_user.id})
		@task = @effort.task
		@efforts = @task.efforts
		authorize! :read, @task
		
		make_breadcrumbs

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @efforts }
		end
	end

	# GET /efforts/1
	# GET /efforts/1.json
	def show
		@effort = Effort.find(params[:id])
		
		make_breadcrumbs

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @effort }
		end
	end

	# GET /efforts/new
	# GET /efforts/new.json
	def new
		@effort = Effort.new({task_id: params[:task_id], user_id: present_user.id})
		
		last_effort = Effort.where(user_id: present_user.id).order("created_at DESC").first
		@effort.begin_at = last_effort.end_at+1.minute unless last_effort.nil? or last_effort.end_at.day != DateTime.now.day
		last_task_effort = Effort.where(task_id: params[:task_id]).order("created_at DESC").first
		@effort.progress = last_task_effort.progress unless last_task_effort.nil?

		make_breadcrumbs

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @effort }
		end
	end

	# GET /efforts/1/edit
	def edit
		@effort = Effort.find(params[:id])
		
		make_breadcrumbs
	end

	# POST /efforts
	# POST /efforts.json
	def create
		@effort = Effort.new(params[:effort].merge({task_id: params[:task_id], user_id: present_user.id}))
		if @effort.task.state_type.code == 'new'
			@effort.task.state_type = StateType.find_by_code('inprogress') 
			@effort.task.clientely_type = ClientelyType.find_by_code('none') if @effort.task.clientely_type_id.nil?
			@effort.task.save!
		end
		if @effort.progress == 100
			@effort.task.state_type = StateType.find_by_code('completed?') 
			@effort.task.clientely_type = ClientelyType.find_by_code('none') if @effort.task.clientely_type_id.nil?
			@effort.task.save!
		end
		
		make_breadcrumbs

		respond_to do |format|
			if @effort.save
				format.html { redirect_to project_task_path(@effort.task.project_id, @effort.task_id), notice: t('app.projects.tasks.efforts.created') }
				format.json { render json: @effort, status: :created, location: @effort }
			else
				format.html { render action: "new" }
				format.json { render json: @effort.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /efforts/1
	# PUT /efforts/1.json
	def update
		@effort = Effort.find(params[:id])
		if @effort.progress == 100
			@effort.task.state_type = StateType.find_by_code('completed?') 
			@effort.task.save!
		end
		
		make_breadcrumbs

		respond_to do |format|
			if @effort.update_attributes(params[:effort])
				format.html { redirect_to project_task_path(@effort.task.project_id, @effort.task_id), notice: t('app.projects.tasks.efforts.updated') }
				format.json { head :ok }
			else
				format.html { render action: "edit" }
				format.json { render json: @effort.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /efforts/1
	# DELETE /efforts/1.json
	def destroy
		@effort = Effort.find(params[:id])
		@effort.destroy

		respond_to do |format|
			format.html { redirect_to project_task_url(@effort.task.project_id, @effort.task_id) }
			format.json { head :ok }
		end
	end
	
	private
	def make_breadcrumbs
		idgrandpa = 'project';
		idparent = 'task';
		idname = 'effort';
		
		case self.action_name
		when 'index' then
			breadcrumbs.add t("page.title.#{idgrandpa.pluralize}.show")+' '+eval("@#{idname}.#{idparent}.#{idgrandpa}.name"), eval("#{idgrandpa}_path @#{idname}.#{idparent}.#{idgrandpa}_id")
			breadcrumbs.add t("page.title.#{idparent.pluralize}.show")+' '+eval("@#{idname}.#{idparent}.name"), eval("#{idgrandpa}_#{idparent}_path @#{idname}.#{idparent}.#{idgrandpa}_id, @#{idname}.#{idparent}_id")
			breadcrumbs.add t("page.title.#{idname.pluralize}.index")
		when 'new','create' then
			breadcrumbs.add t("page.title.#{idgrandpa.pluralize}.show")+' '+eval("@#{idname}.#{idparent}.#{idgrandpa}.name"), eval("#{idgrandpa}_path @#{idname}.#{idparent}.#{idgrandpa}_id")
			breadcrumbs.add t("page.title.#{idparent.pluralize}.show")+' '+eval("@#{idname}.#{idparent}.name"), eval("#{idgrandpa}_#{idparent}_path @#{idname}.#{idparent}.#{idgrandpa}_id, @#{idname}.#{idparent}_id")
			breadcrumbs.add t("page.title.#{idname.pluralize}.new")
		when 'show' then
			breadcrumbs.add t("page.title.#{idgrandpa.pluralize}.show")+' '+eval("@#{idname}.#{idparent}.#{idgrandpa}.name"), eval("#{idgrandpa}_path @#{idname}.#{idparent}.#{idgrandpa}_id")
			breadcrumbs.add t("page.title.#{idparent.pluralize}.show")+' '+eval("@#{idname}.#{idparent}.name"), eval("#{idgrandpa}_#{idparent}_path @#{idname}.#{idparent}.#{idgrandpa}_id, @#{idname}.#{idparent}_id")
			breadcrumbs.add t("page.title.#{idname.pluralize}.show")+' '+eval("@#{idname}.name")
		when 'edit', 'update' then
			breadcrumbs.add t("page.title.#{idgrandpa.pluralize}.show")+' '+eval("@#{idname}.#{idparent}.#{idgrandpa}.name"), eval("#{idgrandpa}_path @#{idname}.#{idparent}.#{idgrandpa}_id")
			breadcrumbs.add t("page.title.#{idparent.pluralize}.show")+' '+eval("@#{idname}.#{idparent}.name"), eval("#{idgrandpa}_#{idparent}_path @#{idname}.#{idparent}.#{idgrandpa}_id, @#{idname}.#{idparent}_id")
			breadcrumbs.add t("page.title.#{idname.pluralize}.edit")+' '+eval("@#{idname}.name")
		else
			# nic
		end
	end
	
	def set_title
		# ono se to bere z toho load_and_authorize_resource
		@effort.task_id ||= params[:task_id]
		@title = (@effort.name.nil? ? '':@effort.name+' - ')+@effort.task.name unless @effort.nil?
	end
end
