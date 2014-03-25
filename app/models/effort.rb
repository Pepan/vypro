class Effort < ActiveRecord::Base
	belongs_to :user
	belongs_to :task


	# @param [Date] from
	# @param [Date] to
	def self.of_period(from, to)
		where('efforts.created_at > ? AND efforts.created_at < ?', from, to)
	end

	# @param [User] user
	def self.of_user(user)
		case
			when user.is_a?(User) then	where(user_id: user.id)
			when user.is_a?(Integer) then where(user_id: user)
			when user.blank? then where(nil)
			else raise "wrong param : #{user.inspect}"
		end

	end

	def name
		return task.name if super.nil? or super.empty?
		super
	end

	alias_method :to_s, :name
end
