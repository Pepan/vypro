class EventsController < ApplicationController
	# GET /events
	# GET /events.json
	def index
		unless params[:project_id].nil?
			listable_actions = ActionType.where(:code=>['create', 'update', 'destroy', 'approve'])
			
			@event = Event.new( {project_id: params[:project_id]} )
			@project = @event.project
			@events = @project.events.where(:action_type_id => listable_actions)
			#authorize! :read, @project
			make_breadcrumbs
		else
			@events = Event.all
			#authorize! :read, Event
		end

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @events }
		end
	end

	# GET /events/1
	# GET /events/1.json
	def show
		@event = Event.find(params[:id])

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @event }
		end
	end

	# GET /events/new
	# GET /events/new.json
	def new
		@event = Event.new

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @event }
		end
	end

	# GET /events/1/edit
	def edit
		@event = Event.find(params[:id])
	end

	# POST /events
	# POST /events.json
	def create
		@event = Event.new(params[:event])

		respond_to do |format|
			if @event.save
				format.html { redirect_to @event, notice: t('app.events.created') }
				format.json { render json: @event, status: :created, location: @event }
			else
				format.html { render action: "new" }
				format.json { render json: @event.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /events/1
	# PUT /events/1.json
	def update
		@event = Event.find(params[:id])

		respond_to do |format|
			if @event.update_attributes(params[:event])
				format.html { redirect_to @event, notice: t('app.events.updated') }
				format.json { head :ok }
			else
				format.html { render action: "edit" }
				format.json { render json: @event.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /events/1
	# DELETE /events/1.json
	def destroy
		@event = Event.find(params[:id])
		@event.destroy

		respond_to do |format|
			format.html { redirect_to events_url }
			format.json { head :ok }
		end
	end

	private
	def make_breadcrumbs
		idparent = 'project';
		idname = 'event';
		
		case self.action_name
		when 'index' then
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
end
