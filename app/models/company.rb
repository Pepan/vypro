class Company < ActiveRecord::Base
	belongs_to :by_user, :class_name => User
	has_many :users
	has_many :projects, :dependent => :destroy
	has_many :tasks, through: :projects
	has_many :efforts, through: :tasks

	attr_accessible :name, :description, :address, :idnumber, :by_user_id
	
	validates :name, :description, :address, :idnumber, :by_user_id, :presence => true

	def to_s
		name
	end
end
