class Invoice < ActiveRecord::Base
	belongs_to :invoice_type
	belongs_to :project_user_relation
	alias_method :relation, :project_user_relation

	attr_accessible :number, :sum_czk, :invoice_type_id, :project_user_relation_id

	validates :number, :sum_czk, :invoice_type_id, :project_user_relation_id, :presence => true

	scope :by_type, lambda { |invoice_type|
		{
			:conditions => { :invoice_type_id => invoice_type.id }
		}
	}

	scope :incomes, joins(:invoice_type).where(:invoice_types => {:code => 'income'})
	scope :issues, joins(:invoice_type).where(:invoice_types => {:code => 'issue'})

	def name
		number.to_s
	end
end
