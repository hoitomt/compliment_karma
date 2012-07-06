class CompanyDepartment < ActiveRecord::Base
	belongs_to :company
	has_many :company_department_users
	has_many :users, :through => :company_department_users

  validates_uniqueness_of :name
end
