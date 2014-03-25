class ProjectUserRelation < ActiveRecord::Base
	belongs_to :project
	belongs_to :user
	belongs_to :relation_type
	alias_method :type, :relation_type
	has_many :invoices

	attr_accessible :project_id, :user_id, :relation_type_id, :hour_price_czk
  
	def target_amount
		user.current_project = project
		midledur = ((user.overall_duration[:best] + user.overall_duration[:worst]).to_f / 2.to_f)
		(midledur/60).round(1)*hour_price_czk.to_f
	end
	
	def made
		user.current_project = project
		midledur = ((user.overal_duration_of_completed[:best] + user.overal_duration_of_completed[:worst]).to_f / 2.to_f)
		(midledur/60).round(1)*hour_price_czk.to_f
	end

	def work_off
		user.current_project = project
		midledur = ((user.overall_time_usage).to_f)
		(midledur/3600).round(1)*hour_price_czk.to_f
	end

	def earned
		sum = 0
		invoices.issues.each do |invoice|
			sum += invoice.sum_czk
		end
		sum
	end

	def to_charge
		@charge ||= project.type.code == 'fixed' ? (target_amount - earned) : (work_off - earned)
		((@charge.nil? or @charge < 0) ? 0 : @charge).to_i
	end

	def benefit
		@benefit ||=  made.to_f - work_off.to_f
	end

	def has_benefit?
		benefit > 0
	end

	def role?(role_name)
		return role_name == relation_type.code if role_name.is_a? String
		role_name.include? relation_type.code if role_name.is_a? Array
	end

end
