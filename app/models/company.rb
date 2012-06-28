class Company < ActiveRecord::Base
	# User Representation of the company
	has_one :user, :dependent => :destroy
	# Company Administrator
	has_many :company_administrators
	has_many :users, :through => :company_administrators
end
