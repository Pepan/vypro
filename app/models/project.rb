class Project < ActiveRecord::Base
	belongs_to :company
	belongs_to :project_state_type
	belongs_to :project_type
	alias_method :type, :project_type

	has_many :tasks, :dependent => :destroy, :order => 'state_type_id ASC'
	has_many :efforts, through: :tasks

	has_many :project_user_relations, :dependent => :destroy
	has_many :users, :through => :project_user_relations
	has_many :events, :dependent => :destroy
	has_many :sprints, :dependent => :destroy
	has_many :invoices, :through => :project_user_relations

	attr_accessible :name, :description, :company_id, :user_id, :project_state_type_id, :project_type_id, :work_started_at, :hour_price_czk, :target_price_czk
	attr_accessor :user_id

	validates :name, :description, :company_id, :project_state_type_id, :project_type_id, :presence => true

	after_create :add_current_user_relation

	after_find :prepare_values

	def to_s
		name
	end

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
		return value # aby se vracela nula
	end
	
	def overall_time_usage
		timecount=0
		bug = TaskType.find_by_code 'bug'
		
		self.tasks.includes(:efforts).each do |task|
			next if task.task_type_id == bug.id
			task.efforts.each do |effort|
				timecount += (effort.end_at-effort.begin_at)
			end
		end
		timecount
	end

	def time_usage_limited(from , to , worker_id = nil)
		timecount=0
		bug = TaskType.find_by_code 'bug'

		self.efforts.of_period(from, to).of_user(worker_id).includes(:task).each do |effort|
			next if effort.task.task_type_id == bug.id
			timecount += (effort.end_at-effort.begin_at)
		end
		timecount
	end

	def overall_duration
		if @duration.nil?
			@duration = { best: 0, worst: 0 }
			self.tasks.each do |task|
				@duration[:best] += task.duration_best.duration unless task.duration_best_id.nil?
				@duration[:worst] += task.duration_worst.duration unless task.duration_worst_id.nil?
			end
		end
		@duration
	end

	def overall_duration_of_completed
		if @duration_of_completed.nil?
			@duration_of_completed = { best: 0, worst: 0 }

			states = StateType.where :code => ['completed?','approved']
			types = TaskType.where :code => ['task']

			self.tasks.by_types(types).by_states(states).each do |task|
				@duration_of_completed[:best] += task.duration_best.duration unless task.duration_best_id.nil?
				@duration_of_completed[:worst] += task.duration_worst.duration unless task.duration_worst_id.nil?
			end
		end
		@duration_of_completed
	end


	def moreover_time_usage
		@clientely_type ||= ClientelyType.find_by_code 'moreover'
		timecount=0
		self.tasks.by_clientely(@clientely_type).each do |task|
			task.efforts.each do |effort|
				timecount += (effort.end_at-effort.begin_at)
			end
		end
		timecount
	end

	def moreover_duration
		@clientely_type ||= ClientelyType.find_by_code 'moreover'
		if @mduration.nil?
			@mduration = { best: 0, worst: 0 }
			self.tasks.by_clientely(@clientely_type).each do |task|
				@mduration[:best] += task.duration_best.duration unless task.duration_best_id.nil?
				@mduration[:worst] += task.duration_worst.duration unless task.duration_worst_id.nil?
			end
		end
		@mduration
	end
	
	def younger_time_usage
		timecount=0
		self.tasks.younger_than(self.work_started_at).each do |task|
			task.efforts.each do |effort|
				timecount += (effort.end_at-effort.begin_at)
			end
		end
		timecount
	end

	def younger_duration
		if @yduration.nil?
			@yduration = { best: 0, worst: 0 }
			self.tasks.younger_than(self.work_started_at).each do |task|
				@yduration[:best] += task.duration_best.duration unless task.duration_best_id.nil?
				@yduration[:worst] += task.duration_worst.duration unless task.duration_worst_id.nil?
			end
		end
		@yduration
	end

	def root_tasks
		@root_tasks ||= Task.where(project_id: self.id, task_id: nil).order('state_type_id ASC')
	end
	
	def count_all_tasks
		tasks.count
	end
	
	def count_tasks_by(type_code)
		tasks.where(:state_type_id => StateType.find_by_code(type_code).id).count
	end
	
	def count_remaining_tasks
		tasks.where(:state_type_id => [StateType.find_by_code('new').id, StateType.find_by_code('inprogress').id, StateType.find_by_code('completed?').id ]).count
	end
	
	def count_unfinished_tasks
		tasks.where(:state_type_id => [StateType.find_by_code('new').id, StateType.find_by_code('inprogress').id ]).count
	end
	
	def count_bugs
		tasks.where(:task_type_id => TaskType.find_by_code('bug').id).count
	end
	
	def work_off(time_usage = nil)
		time_usage ||= overall_time_usage
		(time_usage/3600).round(1)*hour_price_czk.to_f
	end

	def worth
		midledur = ((overall_duration[:best] + overall_duration[:worst]).to_f / 2.to_f)
		(midledur/60).round(1)*hour_price_czk.to_f
	end

	def made
		midledur = ((overall_duration_of_completed[:best] + overall_duration_of_completed[:worst]).to_f / 2.to_f)
		(midledur/60).round(1)*hour_price_czk.to_f
	end

	def earned
		sum = 0
		invoices.incomes.each do |invoice|
			sum += invoice.sum_czk
		end
		sum
	end

	def issued
		sum = 0
		invoices.issues.each do |invoice|
			sum += invoice.sum_czk
		end
		sum
	end

	def to_charge
		@charge ||= work_off - earned if type.code == 'agile'
		@charge ||= target_price_czk - earned if type.code == 'fix'

		(@charge.nil? or @charge < 0) ? 0 : @charge
	end

	def benefit
		return earned - work_off if type.code == 'agile'
		return target_price_czk - work_off if type.code == 'fix'
		0
	end
	def has_benefit?
		benefit > 0
	end

	def fund
		return target_price_czk - worth if type.code == 'fix'
		0
	end
	def has_fund?
		fund > 0
	end

	def chief_relation
		project_user_relations.where(relation_type_id: RelationType.find_by_code('chief').id).first
	end

	def profit
		earned - issued
	end
	def has_profit?
		profit > 0
	end

	def duplicate!
		new_prj = self.dup
		new_prj.name = 'dupl_'+name
		new_prj.description = '...'
		new_prj.save!
		project_user_relations.each do |relation|
			new_prj.project_user_relations << relation.dup
		end
		sprints.each do |sprint|
			new_prj.sprints.create
		end
		root_tasks.each do |task|
			task.duplicate_for! new_prj, nil
		end
		new_prj.save!
		new_prj
	end
	private
		def add_current_user_relation
			ProjectUserRelation.create!(
				{
					user_id: self.user_id, 
					project_id: self.id, 
					relation_type_id: RelationType.find_by_code('chief').id
				}
			) if self.user_id
		end

	def prepare_values
		self.target_price_czk = 0 if self.target_price_czk.nil?
	end
end
