class Sprint < ActiveRecord::Base
	belongs_to :project
	has_many :tasks

	before_create :set_new_tier

	def overal_progress
		progrcount = 0
		progrsum = 0
		value = 0
		blocked_state = StateType.find_by_code 'blocked'

		self.tasks.each do |task|
			next if task.state_type_id == blocked_state.id
			progrsum += task.progress unless task.progress.nil?
			progrcount += 1
		end
		value = progrsum / progrcount unless progrsum == 0 or progrcount == 0
		value # aby se vracela nula
	end

	def overall_time_usage
		timecount=0
		bug = TaskType.find_by_code 'bug'

		self.tasks.each do |task|
			next if task.task_type_id == bug.id
			task.efforts.each do |effort|
				timecount += (effort.end_at-effort.begin_at)
			end
		end
		timecount
	end

	def overall_duration
		duration = {best: 0, worst: 0}
		self.tasks.each do |task|
			duration[:best] += task.duration_best.duration unless task.duration_best.nil?
			duration[:worst] += task.duration_worst.duration unless task.duration_worst.nil?
		end
		duration
	end

	def count_all_tasks
		Task.where(:sprint_id => self.id).count
	end

	def count_tasks_by(type_code)
		Task.where(:sprint_id => self.id, :state_type_id => StateType.find_by_code(type_code).id).count
	end

	def count_remaining_tasks
		Task.where(:sprint_id => self.id, :state_type_id => [StateType.find_by_code('new').id, StateType.find_by_code('inprogress').id, StateType.find_by_code('completed?').id]).count
	end

	def count_unfinished_tasks
		Task.where(:sprint_id => self.id, :state_type_id => [StateType.find_by_code('new').id, StateType.find_by_code('inprogress').id]).count
	end

	def events
		tids = []
		Task.where(:sprint_id => self.id).each do |task|
			tids << task.id
		end

		@sprint_events ||= Event.where(
			:project_id => self.project_id,
			:target_class => 'tasks',
			:data_id => tids
		)
	end

	private
	def set_new_tier
		self.tier = (Sprint.where(:project_id => self.project_id).count) + 1
	end
end
