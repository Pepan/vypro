class User < ActiveRecord::Base
	before_validation(:on => :create) do
		self.company_id = Company.find_by_idnumber("0101").id if self.company_id.nil?
		self.user_role_id = UserRole.find_by_code('user').id if self.user_role_id.nil?
	end
	# Include default devise modules. Others available are:
	# :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	       :recoverable, :rememberable, :trackable, :validatable

	# Setup accessible (or protected) attributes for your model
	attr_accessible :firstname, :lastname, :company_id, :user_role_id, :email, :password, :password_confirmation, :remember_me
	belongs_to :user_role
	belongs_to :company
	has_many :created_tasks, :foreign_key => :user_id, :class_name => 'Task'
	has_many :assigned_tasks, :foreign_key => :assigned_user_id, :class_name => 'Task'
	has_many :effors
	has_many :tasks, :foreign_key => :assigned_user_id

	has_many :project_user_relations, :dependent => :destroy
	has_many :projects, :through => :project_user_relations
	has_many :events

	has_many :created_companies, :foreign_key => :by_user_id, :class_name => Company
	has_many :fellows, :through => :created_companies, :source => :users, :class_name => User

	has_many :notes
	has_many :annexes

	attr_accessor :current_project

	def full_name
		firstname + ' ' + lastname
	end

	alias_method :name, :full_name
	alias_method :to_s, :full_name

	def relation_to(project)
		relation = ProjectUserRelation.find_by_project_id_and_user_id(project.id, self.id) unless project.nil?
		relation ||= ProjectUserRelation.new :relation_type_id => RelationType.find_by_code('chief').id if user_role.code == 'admin'
		relation ||= ProjectUserRelation.new
		relation
	end

	def role?(role_name)
		return role_name == user_role.code if role_name.is_a? String
		role_name.include? user_role.code if role_name.is_a? Array
	end

	def active_tasks
		stids = []
		StateType.where(:code => ['new', 'inprogress', 'blocked']).each do |type|
			stids << type.id
		end

		pstids = []
		ProjectStateType.where(:code => ['inprogress']).each do |type|
			pstids << type.id
		end

		pids = []
		Project.where(:project_state_type_id => pstids).each do |project|
			pids << project.id
		end

		@active_tasks ||= Task.where(
				:assigned_user_id => self.id,
				:state_type_id => stids,
				:project_id => pids
		)
	end

	def overal_progress
		progrcount = 0
		progrsum = 0
		value = 0
		blocked_state = StateType.find_by_code 'blocked'

		self.tasks.by_project(current_project).each do |task|
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

		self.tasks.by_project(current_project).each do |task|
			next if task.task_type_id == bug.id
			task.efforts.each do |effort|
				timecount += (effort.end_at-effort.begin_at)
			end
		end
		timecount
	end

	def overall_duration
		if @duration.nil?
			@duration = {best: 0, worst: 0}

			states = StateType.where :code => ['new', 'inprogress', 'completed?', 'approved']
			types = TaskType.where :code => ['task']

			self.tasks.by_project(current_project).by_types(types).by_states(states).each do |task|
				@duration[:best] += task.duration_best.duration unless task.duration_best_id.nil?
				@duration[:worst] += task.duration_worst.duration unless task.duration_worst_id.nil?
			end
		end
		@duration
	end

	def overal_duration_of_completed
		if @duration_of_completed.nil?
			@duration_of_completed = {best: 0, worst: 0}

			states = StateType.where :code => ['completed?', 'approved']
			types = TaskType.where :code => ['task']

			self.tasks.by_project(current_project).by_types(types).by_states(states).each do |task|
				@duration_of_completed[:best] += task.duration_best.duration unless task.duration_best_id.nil?
				@duration_of_completed[:worst] += task.duration_worst.duration unless task.duration_worst_id.nil?
			end
		end
		@duration_of_completed
	end

	def overall_time_usage_of_completed
		timecount=0
		states = StateType.where :code => ['completed?', 'approved']
		types = TaskType.where :code => ['task']

		self.tasks.by_project(current_project).by_types(types).by_states(states).each do |task|
			task.efforts.each do |effort|
				timecount += (effort.end_at-effort.begin_at)
			end
		end
		timecount
	end

	def count_all_tasks
		tasks.by_project(current_project).count
	end

	def count_tasks_by(type_code)
		tasks.by_project(current_project).where(:state_type_id => StateType.find_by_code(type_code).id).count
	end

	def count_remaining_tasks
		tasks.by_project(current_project).where(:state_type_id => [StateType.find_by_code('new').id, StateType.find_by_code('inprogress').id, StateType.find_by_code('completed?').id]).count
	end

	def count_unfinished_tasks
		tasks.by_project(current_project).where(:state_type_id => [StateType.find_by_code('new').id, StateType.find_by_code('inprogress').id]).count
	end

	def tasks_for project
		tasks.by_project project
	end

end
