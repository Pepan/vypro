class Ability
	include CanCan::Ability

	def initialize(user)
		# Define abilities for the passed in user here. For example:
		#
		#   user ||= User.new # guest user (not logged in)
		#   if user.admin?
		#     can :manage, :all
		#   else
		#     can :read, :all
		#   end
		#
		# The first argument to `can` is the action you are giving the user permission to do.
		# If you pass :manage it will apply to every action. Other common actions here are
		# :read, :create, :update and :destroy.
		#
		# The second argument is the resource the user can perform the action on. If you pass
		# :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
		#
		# The third argument is an optional hash of conditions to further filter the objects.
		# For example, here the user can only update published articles.
		#
		#   can :update, Article, :published => true
		#
		# See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
		user ||= User.find( 1 ) # guest user (not logged in)
		if user.role? 'admin'
			can :manage, :all
		end
		if user.role? 'user'
			can :read, User, :id => user.id
			can :create, User
			can :manage, User do |muser|
				user.created_companies.include? muser.company
			end

			can :create, Company
			can :manage, Company do |company|
				user.id == company.by_user_id
			end
			
			can :create, Project
			
			can [:update, :destroy], Project do |project|
				!user.relation_to(project).relation_type.nil? and user.relation_to(project).relation_type.code == 'chief'
			end
			can [:read], Project do |project|
				!user.relation_to(project).relation_type.nil?
			end

			Rails.logger.info user.inspect

			unless user.relation_to(user.current_project).relation_type.nil?
				can [:create, :read, :approve, :tree ], Task
				can [:moreover ], Task do |task|
					user.relation_to(task.project).relation_type.code == 'chief' or user.relation_to(task.project).relation_type.code == 'client'
				end
				can [:update, :destroy], Task do |task|
					task.user_id == user.id
				end

				can [:create], Effort
				can [:read, :update, :destroy], Effort do |effort|
					effort.user_id == user.id
				end

				can [:create, :read], Note
				can [:read, :update, :destroy], Note do |note|
					note.user_id == user.id
				end
				can [:read ], Sprint
				can [:read ], ProjectUserRelation do |relation|
					relation.user_id == user.id
				end
				if user.relation_to(user.current_project).role? %w(client developer)
					can [:index ], Invoice
				end
				can [:create, :read], Annex
				can [:read, :update, :destroy], Annex do |annex|
					annex.user_id == user.id
				end
			end
			
			can [:read, :update, :destroy], Task do |task|
				!user.relation_to(task.project).relation_type.nil? and user.relation_to(task.project).relation_type.code == 'chief'
			end
			can [:read, :update], Task do |task|
				task.assigned_user_id == user.id
			end

			if !user.relation_to(user.current_project).relation_type.nil? and user.relation_to(user.current_project).relation_type.code == 'chief'
				can :manage, ProjectUserRelation
				can :manage, Sprint
			end

		end
	end
end
