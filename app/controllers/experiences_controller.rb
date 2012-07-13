class ExperiencesController < ApplicationController
	before_filter :set_user

	def new
		@experience = Experience.new
	end

	def create
		@experience = Experience.new(params[:experience])
		@experience.user = @user
		if @experience.save
			@professional_experiences = @user.experiences
		else
			render 'new'
		end
	end

	def edit
		@experience = Experience.find(params[:experience_id])
	end

	def update
		@experience = Experience.find(params[:id])
		@experience.update_attributes(params[:experience])
		@professional_experiences = @user.experiences
	end

	private
		def set_user
			@user = User.find(params[:id])
		end

end
