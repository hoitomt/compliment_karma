class CompanyDepartmentUser < ActiveRecord::Base
	belongs_to :company_department
	belongs_to :user
end
