class AnnexesController < ApplicationController
	load_and_authorize_resource

	# GET /annexes
	# GET /annexes.json
	def index
		@annexes = Annex.all

		@annex = Note.new({task_id: params[:task_id], user_id: present_user.id})
		@task = @annex.task
		@annexes = @task.annexs
		authorize! :read, @task

		make_breadcrumbs

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @annexes }
		end
	end

	# GET /annexes/1
	# GET /annexes/1.json
	def show
		@annex = Annex.find(params[:id])

		make_breadcrumbs

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @annex }
		end
	end

	# GET /annexes/new
	# GET /annexes/new.json
	def new
		@annex = Annex.new({task_id: params[:task_id], user_id: present_user.id})

		make_breadcrumbs

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @annex }
		end
	end

	# GET /annexes/1/edit
	def edit
		@annex = Annex.find(params[:id])

		make_breadcrumbs
	end

	# POST /annexes
	# POST /annexes.json
	def create
		@annex = Annex.new(params[:annex].merge({task_id: params[:task_id], user_id: present_user.id}))

		make_breadcrumbs

		respond_to do |format|
			if @annex.save
				format.html { redirect_to project_task_path(@annex.task.project_id, @annex.task_id), notice: t('app.projects.tasks.annex.created') }
				format.json { render json: @annex, status: :created, location: @annex }
			else
				format.html { render action: "new" }
				format.json { render json: @annex.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /annexes/1
	# PUT /annexes/1.json
	def update
		@annex = Annex.find(params[:id])

		make_breadcrumbs

		respond_to do |format|
			if @annex.update_attributes(params[:annex])
				format.html { redirect_to project_task_path(@annex.task.project_id, @annex.task_id), notice: t('app.projects.tasks.annex.updated') }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @annex.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /annexes/1
	# DELETE /annexes/1.json
	def destroy
		@annex = Annex.find(params[:id])
		@annex.destroy

		respond_to do |format|
			format.html { redirect_to project_task_url(@annex.task.project_id, @annex.task_id) }
			format.json { head :no_content }
		end
	end

	private
	def make_breadcrumbs
		idgrandpa = 'project';
		idparent = 'task';
		idname = 'annex';

		case self.action_name
			when 'index' then
				breadcrumbs.add t("page.title.#{idgrandpa.pluralize}.show")+' '+eval("@#{idname}.#{idparent}.#{idgrandpa}.name"), eval("#{idgrandpa}_path @#{idname}.#{idparent}.#{idgrandpa}_id")
				breadcrumbs.add t("page.title.#{idparent.pluralize}.show")+' '+eval("@#{idname}.#{idparent}.name"), eval("#{idgrandpa}_#{idparent}_path @#{idname}.#{idparent}.#{idgrandpa}_id, @#{idname}.#{idparent}_id")
				breadcrumbs.add t("page.title.#{idname.pluralize}.index")
			when 'new', 'create' then
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
end
