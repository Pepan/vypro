class TimeSheetsController < ApplicationController
  def index
	  @time_sheet = TimeSheet.new(from: 2.month.ago.to_date, to: Date.current, company_id: nil, worker_id:nil)

	  @companies = present_user.created_companies.includes(:projects)

	  respond_to do |format|
		  format.html # index.html.erb
	  end

  end

	def create
		filter_val = params[:time_sheet]
		@time_sheet = TimeSheet.new(
				from: Date.new(filter_val['from(1i)'].to_i, filter_val['from(2i)'].to_i, filter_val['from(3i)'].to_i ),
				to: Date.new(filter_val['to(1i)'].to_i, filter_val['to(2i)'].to_i, filter_val['to(3i)'].to_i),
				company_id: filter_val[:company_id],
				worker_id: filter_val[:worker_id]
		)

		@companies = [Company.find(@time_sheet.company_id)] unless @time_sheet.company_id.blank?
		@companies ||= present_user.created_companies.includes(:projects)

		respond_to do |format|
			format.js
		end

	end

end
