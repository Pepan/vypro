class InvoicesController < ApplicationController
	load_and_authorize_resource
	before_filter :set_title, :only => [:show, :edit]

	# GET /invoices
	# GET /invoices.json
	def index
		@relation = ProjectUserRelation.find params[:project_user_relation_id]

		if current_user.relation_to(@relation.project).role? %w(chief client)
			if current_user.relation_to(@relation.project).role? 'chief'
				if @relation.user == current_user
					@incomes = @relation.invoices.incomes

					@income_sum = 0
					@incomes.each do |invoice|
						@income_sum += invoice.sum_czk
					end

					@issues = @relation.project.invoices.issues
				else
					@issues = @relation.invoices.issues
				end
			end
			if current_user.relation_to(@relation.project).role? 'client'
				@issues = @relation.invoices.incomes
			end

		else
			@issues = @relation.invoices.issues
		end

		@issues_sum = 0
		@issues.each do |invoice|
			@issues_sum += invoice.sum_czk
		end

		make_breadcrumbs

		respond_to do |format|
			format.html # index.html.erb
			format.json { render json: @relation.invoices }
		end
	end

	# GET /invoices/1
	# GET /invoices/1.json
	def show
		@invoice = Invoice.find(params[:id])
		@relation = @invoice.project_user_relation

		make_breadcrumbs

		respond_to do |format|
			format.html # show.html.erb
			format.json { render json: @invoice }
		end
	end

	# GET /invoices/new
	# GET /invoices/new.json
	def new
		project = Project.find params[:project_id]
		@invoice = Invoice.new(
			project_user_relation_id: params[:project_user_relation_id],
			invoice_type_id: InvoiceType.find_by_code(params[:type]).id,
		    sum_czk: project.to_charge
		)
		@relation = @invoice.project_user_relation
		@invoice.sum_czk = @relation.to_charge if @relation.user != current_user

		make_breadcrumbs

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @invoice }
		end
	end

	# GET /invoices/1/edit
	def edit
		@invoice = Invoice.find(params[:id])
		@relation = @invoice.project_user_relation

		make_breadcrumbs
	end

	# POST /invoices
	# POST /invoices.json
	def create
		@invoice = Invoice.new(params[:invoice].merge({project_user_relation_id: params[:project_user_relation_id]}))
		@relation = @invoice.project_user_relation

		make_breadcrumbs

		respond_to do |format|
			if @invoice.save
				format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
				format.json { render json: @invoice, status: :created, location: @invoice }
			else
				format.html { render action: "new" }
				format.json { render json: @invoice.errors, status: :unprocessable_entity }
			end
		end
	end

	# PUT /invoices/1
	# PUT /invoices/1.json
	def update
		@invoice = Invoice.find(params[:id])
		@relation = @invoice.project_user_relation

		make_breadcrumbs

		respond_to do |format|
			if @invoice.update_attributes(params[:invoice])
				format.html { redirect_to @invoice, notice: 'Invoice was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: "edit" }
				format.json { render json: @invoice.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /invoices/1
	# DELETE /invoices/1.json
	def destroy
		@invoice = Invoice.find(params[:id])
		@invoice.destroy

		respond_to do |format|
			format.html { redirect_to invoices_url }
			format.json { head :no_content }
		end
	end

	private
	def make_breadcrumbs
		project_user_relation = @relation
		idparentparent = 'project';
		idparent = 'project_user_relation';
		idname = 'invoice';

		case self.action_name
			when 'index' then
				breadcrumbs.add t("page.title.#{idparentparent.pluralize}.show")+' '+eval("#{idparent}.#{idparentparent}.name"), eval("#{idparentparent}_path #{idparent}.#{idparentparent}_id")
				breadcrumbs.add t("page.title.#{idparent.pluralize}.show")+' '+eval("#{idparent}.user.name"), eval("#{idparent}_path #{idparent}.#{idparentparent}_id, #{idparent}.id")
				breadcrumbs.add t("page.title.#{idname.pluralize}.index")
			when 'new','create' then
				breadcrumbs.add t("page.title.#{idparentparent.pluralize}.show")+' '+eval("#{idparent}.#{idparentparent}.name"), eval("#{idparentparent}_path #{idparent}.#{idparentparent}_id")
				breadcrumbs.add t("page.title.#{idparent.pluralize}.show")+' '+eval("#{idparent}.user.name"), eval("#{idparent}_path #{idparent}.#{idparentparent}_id, #{idparent}.id")
				breadcrumbs.add t("page.title.#{idname.pluralize}.new")
			when 'show' then
				breadcrumbs.add t("page.title.#{idparentparent.pluralize}.show")+' '+eval("#{idparent}.#{idparentparent}.name"), eval("#{idparentparent}_path #{idparent}.#{idparentparent}_id")
				breadcrumbs.add t("page.title.#{idparent.pluralize}.show")+' '+eval("#{idparent}.user.name"), eval("#{idparent}_path #{idparent}.#{idparentparent}_id, #{idparent}.id")
				breadcrumbs.add eval("@#{idname}.number")
			when 'edit', 'update' then
				breadcrumbs.add t("page.title.#{idparentparent.pluralize}.show")+' '+eval("#{idparent}.#{idparentparent}.name"), eval("#{idparentparent}_path #{idparent}.#{idparentparent}_id")
				breadcrumbs.add t("page.title.#{idparent.pluralize}.show")+' '+eval("#{idparent}.user.name"), eval("#{idparent}_path #{idparent}.#{idparentparent}_id, #{idparent}.id")
				breadcrumbs.add t("page.title.#{idname.pluralize}.edit")+' '+eval("@#{idname}.number")
			else
				# nic
		end
	end

	def set_title
		# ono se to bere z toho load_and_authorize_resource
		puts '2. '+@project_user_relation.inspect
		@title = @project_user_relation.user.full_name+' - '+@project_user_relation.project.name unless @project_user_relation.nil?
	end
end
