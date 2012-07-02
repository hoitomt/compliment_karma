class CompanyUser < ActiveRecord::Base
	belongs_to :company
	belongs_to :user
	after_create :add_company_follow_employee

	def self.administers_company?(user_id, company_id)
		c = CompanyUser.where("user_id = ? AND company_id = ? AND administrator = 'true'", 
													user_id, company_id).count
		return c > 0
	end

	def add_company_follow_employee
		company = Company.find(self.company_id)
		company.follow_employee(self.user_id)
	end
end
