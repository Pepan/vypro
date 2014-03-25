class Task < ActiveRecord::Base
	before_save :update_state
	
	belongs_to :project
	belongs_to :task_type
	belongs_to :user
	belongs_to :state_type
	belongs_to :assigned_user, :class_name=>'User'
	belongs_to :duration_best, :class_name=>'DurationType'
	belongs_to :duration_worst, :class_name=>'DurationType'
	belongs_to :approved_by_user, :class_name=>'User'
	belongs_to :sprint
	belongs_to :task #parent
	belongs_to :clientely_type
	belongs_to :priority_type

	has_many :efforts, :dependent => :destroy
	has_many :tasks, :dependent => :destroy
	has_many :notes, :dependent => :destroy
	has_many :annexes, :dependent => :destroy

	validates :name, :description, :assigned_user, :state_type, :duration_best, :duration_worst, :clientely_type_id, :priority_type_id, :presence => true
	validate :correct_duration_order
	
	#default_scope order("created_at ASC")
	scope :by_project, lambda { |project|
		{
			:conditions => { :project_id => project.id }
		}
	}

	scope :by_clientely, lambda { |clientely_type|
		{
			:conditions => { :clientely_type_id => clientely_type.id }
		}
	}
	
	scope :younger_than, lambda { |datetime|
		{
			:conditions => ["created_at > ?", datetime.to_s]
		}
	}

	scope :by_states, lambda { |state_types|
		{
			:conditions => { :state_type_id => state_types }
		}
	}

	scope :by_types, lambda { |task_types|
		{
			:conditions => { :task_type_id => task_types }
		}
	}

	scope :with_work, where(state_type_id: StateType.where(code: ['inprogress', 'completed?', 'approved']))

	def to_s
		t_name
	end
	def t_name
		task_type.t_name.mb_chars.downcase.to_s + ' ' + name.camelcase
	end
	def t_full_name
		state_type.t_name + ' ' + task_type.t_name.mb_chars.downcase.to_s + ' ' + name.camelcase
	end
	
	def time_usage
		if @timecount.nil?
			@timecount=0
			efforts.each do |effort|
				@timecount += (effort.end_at - effort.begin_at)
			end
		end
		@timecount
	end

	def time_usage_limited(from , to , worker_id = nil)
		if @timecount.nil?
			@timecount=0
			efforts.of_period(from, to).of_user(worker_id).each do |effort|
				@timecount += (effort.end_at - effort.begin_at)
			end
		end
		@timecount
	end

	def overall_time_usage
		if @overaltimecount.nil?
			@overaltimecount = time_usage
			bug = TaskType.find_by_code 'bug'
			
			self.tasks.each do |task|
				next if task.task_type_id == bug.id
				@overaltimecount += task.overall_time_usage
			end
		end
		@overaltimecount
	end
	
	def progress
		return 0 if efforts.empty?
		efforts.last.progress
	end
	
	def efforts_for(user)
		Effort.find_by_task_id_and_user_id(self.id, user.id)
	end

	def subtasks_duration
		duration = { best: 0, worst: 0 }
		self.tasks.each do |task|
			duration[:best] += task.duration_best.duration + task.subtasks_duration[:best]
			duration[:worst] += task.duration_worst.duration + task.subtasks_duration[:worst]
		end
		duration
	end

	def worth(hour_price_czk)
		midledur = ((duration_best.duration + duration_worst.duration).to_f / 2.to_f)
		(midledur/60).round(1)*hour_price_czk.to_f
	end

	def duplicate_for!(project, task)
		new_task = self.dup
		new_task.project = project
		new_task.task = task
		new_task.sprint = project.sprints.where( tier: self.sprint.tier).first if self.sprint
		new_task.save!
		tasks.each do |task|
			task.duplicate_for! project, new_task
		end
		clone
	end

	private
	def update_state
		# upravit stav nadukolu
		#puts task.name +' - '+ task.state_type.t_name if !task.nil? 
		unless task.nil?
			task.state_type = self.state_type if self.state_type.code == 'inprogress' and task.state_type.code == 'new'
			task.clientely_type = ClientelyType.find_by_code('none') if task.clientely_type_id.nil?
			task.save!
		end
		true
	end
	def correct_duration_order
		return if duration_worst.nil? and duration_best.nil?
		if duration_worst.duration.to_int < duration_best.duration.to_int
			errors.add(:duration_worst, I18n.t("app.projects.tasks.duration_wrong"))
		end		
	end
end
