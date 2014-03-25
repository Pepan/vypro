class UsersController < ApplicationController
	load_and_authorize_resource :except => :create
	
	# GET /users
	# GET /users.json
	def index
		@user = User.new({company_id: params[:company_id]})
		@company = @user.company
		@users = @company.users
		authorize! :manage, @company
		
		make_breadcrumbs

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @users }
		end
	end

	# GET /users/1
	# GET /users/1.json
	def show
		@user = User.find(params[:id])
		make_breadcrumbs

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @user }
		end
	end

	# GET /users/new
	# GET /users/new.json
	def new
		@user = User.new({company_id: params[:company_id]})
		make_breadcrumbs

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @user }
		end
	end

	# GET /users/1/edit
	def edit
		@user = User.find(params[:id])
		make_breadcrumbs
	end

	# POST /users
	# POST /users.json
	def create
		@user = User.new(params[:user].merge({company_id: params[:company_id], password_confirmation: params[:user][:password]}))
		authorize! :create, @user
		make_breadcrumbs
		
		respond_to do |format|
			if @user.save
				format.html { redirect_to company_user_path(@user.company_id, @user.id), notice: t('app.companies.users.created') }
				format.json { render json: @user, status: :created, location: @user }
			else
				format.html { render action: "new" }
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /users/1
	# PUT /users/1.json
	def update
		@user = User.find(params[:id])
		make_breadcrumbs
		
		respond_to do |format|
			if @user.update_attributes(params[:user])
				format.html { redirect_to company_user_path(@user.company_id, @user.id), notice: t('app.companies.users.updated') }
				format.json { head :ok }
			else
				format.html { render action: "edit" }
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /users/1
	# DELETE /users/1.json
	def destroy
		@user = User.find(params[:id])
		@user.destroy
		make_breadcrumbs

		respond_to do |format|
			format.html { redirect_to users_url }
			format.json { head :ok }
		end
	end
	
	private
	def make_breadcrumbs
		idparent = 'company';
		idname = 'user';
		
		case self.action_name
		when 'index' then
			breadcrumbs.add t("page.title.#{idparent.pluralize}.show")+' '+eval("@#{idname}.#{idparent}.name"), eval("#{idparent}_path @#{idname}.#{idparent}_id")
			breadcrumbs.add t("page.title.#{idname.pluralize}.index")
		when 'new','create' then
			breadcrumbs.add t("page.title.#{idparent.pluralize}.show")+' '+eval("@#{idname}.#{idparent}.name"), eval("#{idparent}_path @#{idname}.#{idparent}_id")
			breadcrumbs.add t("page.title.#{idname.pluralize}.new")
		when 'show' then
			breadcrumbs.add t("page.title.#{idparent.pluralize}.show")+' '+eval("@#{idname}.#{idparent}.name"), eval("#{idparent}_path @#{idname}.#{idparent}_id")
			breadcrumbs.add eval("@#{idname}.full_name")
		when 'edit', 'update' then
			breadcrumbs.add t("page.title.#{idparent.pluralize}.show")+' '+eval("@#{idname}.#{idparent}.name"), eval("#{idparent}_path @#{idname}.#{idparent}_id")
			breadcrumbs.add t("page.title.#{idname.pluralize}.edit")+' '+eval("@#{idname}.full_name")
		else
			# nic
		end
	end
end
