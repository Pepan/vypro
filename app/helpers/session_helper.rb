module SessionHelper
	# @return [User]
	def present_user
		@present_user ||= ( user_signed_in? ? current_user : User.find( 1 ) )
	end

end
