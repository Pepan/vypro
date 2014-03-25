module ProjectsHelper
	def to_duration (value)
		# minutes = (value % 60).to_int
		# hours = (value / 60).to_int
		
		# "#{hours}:#{minutes}"
		(value/60).round(1).to_s
	end
	def to_timeusage (value)
		(value/3600).round(1).to_s
	end
end
