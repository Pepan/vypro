class NotesController < ApplicationController
	load_and_authorize_resource

	# GET /notes
	# GET /notes.json
	def index
		@note = Note.new({task_id: params[:task_id], user_id: present_user.id})
		@task = @note.task
		@notes = @task.notes
		authorize! :read, @task

		make_breadcrumbs

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @notes }
		end
	end

	# GET /notes/1
	# GET /notes/1.json
	def show
		@note = Note.find(params[:id])

		make_breadcrumbs

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @note }
		end
	end

	# GET /notes/new
	# GET /notes/new.json
	def new
		@note = Note.new({task_id: params[:task_id], user_id: present_user.id})

		make_breadcrumbs

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @note }
		end
	end

	# GET /notes/1/edit
	def edit
		@note = Note.find(params[:id])

		make_breadcrumbs

	end

	# POST /notes
	# POST /notes.json
	def create
		@note = Note.new(params[:note].merge({task_id: params[:task_id], user_id: present_user.id}))

		make_breadcrumbs

		respond_to do |format|
			if @note.save
				format.html { redirect_to project_task_path(@note.task.project_id, @note.task_id), notice: t('app.projects.tasks.notes.created') }
				format.json { render json: @note, status: :created, location: @note }
			else
				format.html { render action: "new" }
				format.json { render json: @note.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /notes/1
	# PUT /notes/1.json
	def update
		@note = Note.find(params[:id])

		make_breadcrumbs

		respond_to do |format|
			if @note.update_attributes(params[:note])
				format.html { redirect_to project_task_path(@note.task.project_id, @note.task_id), notice: t('app.projects.tasks.notes.updated') }
				format.json { head :ok }
			else
				format.html { render action: "edit" }
				format.json { render json: @note.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /notes/1
	# DELETE /notes/1.json
	def destroy
		@note = Note.find(params[:id])
		@note.destroy

		respond_to do |format|
			format.html { redirect_to project_task_url(@note.task.project_id, @note.task_id) }
			format.json { head :ok }
		end
	end
	
	private
	def make_breadcrumbs
		idgrandpa = 'project';
		idparent = 'task';
		idname = 'note';
		
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
end
