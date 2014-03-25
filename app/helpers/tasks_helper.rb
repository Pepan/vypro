module TasksHelper
	def line_of(task, level)
		[
			task.state_type.t_name,
			('  '*level)+task.name, 
			#(''+task.description.gsub("\r\n", ' ')+'').html_safe,
			task.progress,
			'',
			'',
			number_with_precision((task.time_usage/3600), :locale => :cz, :precision => 1), 
			t('app.projects.tasks.hours'), 
			task.duration_best.t_name.split(' ').first, 
			task.duration_best.t_name.split(' ').last, 
			task.duration_worst.t_name.split(' ').first, 
			task.duration_worst.t_name.split(' ').last,
			number_with_precision(task.duration_best.duration/60, :locale => :cz, :precision => 1), 
			number_with_precision(task.duration_worst.duration/60, :locale => :cz, :precision => 1), 
			t('app.projects.tasks.hours')
		].join '|'
	end
	
	def work_of(task, level)
		out = ''
		task.efforts.each do |effort|
			line = [
				'',
				('  '*level)+effort.name, 
				#effort.description,
				effort.progress,
				l(effort.begin_at, :format => :short),
				l(effort.end_at, :format => :short),
				number_with_precision(((effort.end_at - effort.begin_at)/3600), :locale => :cz, :precision => 1),
				t('app.projects.tasks.hours'), 
				'',
				'',
				'',
				'',
				'',
				'',
				''
			].join '|'
			out << line << "\r\n"
		end
		out
	end
	
	def sub_tree(tasks, level)
		out = ''
		tasks.each do |task|
			out << line_of(task, level) << "\r\n"
			out << work_of(task, level) << "\r\n"
			out << sub_tree(task.tasks, level.to_i+1)
		end
		out
	end
	
end
