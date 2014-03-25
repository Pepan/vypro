class CompaniesController < ApplicationController
	load_and_authorize_resource

	# GET /companies
	# GET /companies.json
	def index
		if current_user.user_role.code == 'admin'
			@companies = Company.all
		else
			@companies = current_user.created_companies
		end
		make_breadcrumbs

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @companies }
		end
	end

	# GET /companies/1
	# GET /companies/1.json
	def show
		@company = Company.find(params[:id])
		make_breadcrumbs

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @company }
		end
	end

	# GET /companies/new
	# GET /companies/new.json
	def new
		@company = Company.new
		make_breadcrumbs

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @company }
		end
	end

	# GET /companies/1/edit
	def edit
		@company = Company.find(params[:id])
		make_breadcrumbs
	end

	# POST /companies
	# POST /companies.json
	def create
		@company = Company.new(params[:company].merge({:by_user_id => current_user.id}))
		make_breadcrumbs

		respond_to do |format|
			if @company.save
				format.html { redirect_to @company, notice: t('app.companies.created') }
				format.json { render json: @company, status: :created, location: @company }
			else
				format.html { render action: "new" }
				format.json { render json: @company.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /companies/1
	# PUT /companies/1.json
	def update
		@company = Company.find(params[:id])
		make_breadcrumbs

		respond_to do |format|
			if @company.update_attributes(params[:company])
				format.html { redirect_to @company, notice: t('app.companies.updated') }
				format.json { head :ok }
			else
				format.html { render action: "edit" }
				format.json { render json: @company.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /companies/1
	# DELETE /companies/1.json
	def destroy
		@company = Company.find(params[:id])
		@company.destroy

		respond_to do |format|
			format.html { redirect_to companies_url }
			format.json { head :ok }
		end
	end

	private
	def make_breadcrumbs
		idname = 'company';
		
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
end
