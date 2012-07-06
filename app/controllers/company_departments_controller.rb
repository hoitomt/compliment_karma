class CompanyDepartmentsController < ApplicationController
	def new
		@company = Company.find(params[:company_id])
		@company_department = CompanyDepartment.new(:company_id => @company.id)
	end

	def create
		@company = Company.find(params[:company_id])
		@company_department = CompanyDepartment.new(params[:company_department])
		if @company_department.save
			redirect_to @company.user
		else
			render 'new'
		end
	end
end
