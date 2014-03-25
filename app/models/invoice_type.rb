class InvoiceType < ActiveRecord::Base
	attr_accessible :code

	validates :code, :presence => true
	validates_uniqueness_of :code

	def t_name
		I18n.t('app.projects.users.relation.invoices.type.'+code)
	end
	alias_method :to_s, :t_name
end
