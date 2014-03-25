class Note < ActiveRecord::Base
	belongs_to :user
	belongs_to :task
  
	def name
		width = 40
		if @pseudoname.nil? or @pseudoname.empty?
			@pseudoname = self.content[0..width] 
			@pseudoname << '...' if self.content.length>width
		end
		@pseudoname
	end
end
