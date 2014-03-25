# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Company.create(
	:name => "Only users",
	:idnumber => "0101",
	:address => "earth",
    :description => 'everybody',
    :by_user_id => 2
)

UserRole.create(
	:code => "guest"
)
UserRole.create(
	:code => "admin"
)
UserRole.create(
	:code => "user"
)

User.create(
	:firstname => "Unknown",
	:lastname => "Guest",
	:email => "host@vypro.cz",
	:password => "unknown",
	:password_confirmation => "unknown",
	:company_id => 1, # Only users
	:user_role_id => 1 # guest
)
User.create(
	:firstname => "Super",
	:lastname => "Admin",
	:email => "admin@vypro.cz",
	:password => "cukrkava",
	:password_confirmation => "cukrkava",
	:company_id => 1, # Only users
	:user_role_id => 2 # admin
)

ActionType.create(
	:code => "create"
)
ActionType.create(
	:code => "read"
)
ActionType.create(
	:code => "update"
)
ActionType.create(
	:code => "destroy"
)

TaskType.create(
	:code => "task"
)
TaskType.create(
	:code => "bug"
)

StateType.create(
	:code => "new"
)
StateType.create(
	:code => "inprogress"
)
StateType.create(
	:code => "completed?"
)
StateType.create(
	:code => "blocked"
)
StateType.create(
	:code => "approved"
)

RelationType.create(
	:code => "developer"
)
RelationType.create(
	:code => "designer"
)
RelationType.create(
	:code => "chief"
)
RelationType.create(
	:code => "brigade"
)
RelationType.create(
	:code => "client"
)
