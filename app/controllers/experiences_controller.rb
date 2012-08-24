class ExperiencesController < ApplicationController
	before_filter :authenticate, :except => [:new, :edit]
	before_filter :set_user

  @@date_format = "%m/%d/%Y"

	def new
		@experience = Experience.new
	end

	def create
		@experience = Experience.new(params[:experience])
		@experience.user = @user
		@experience.start_date = parse_date(params[:experience][:start_date])
		@experience.end_date = parse_date(params[:experience][:end_date])
		@experience.state_cd = params[:state_cd_txt] if @experience.country != "United States"
		if @experience.save
			@professional_experiences = @user.experiences
			@current_experience = @user.experiences.first
			logger.info("Pro Exp: #{@professional_experiences.count}")
		else
			render 'new'
		end
	end

	def edit
		@experience = Experience.find(params[:experience_id])
		logger.info("Start Date: #{@experience.start_date}")
		logger.info("End Date: #{@experience.end_date}")
	end

	def update
		@experience = Experience.find(params[:experience_id])		
		@experience.update_attributes(params[:experience])

		@experience.start_date = parse_date(params[:experience][:start_date])
		@experience.end_date = parse_date(params[:experience][:end_date])
		@experience.state_cd = params[:state_cd_txt] if @experience.country != "United States"
		@experience.save

		@professional_experiences = @user.experiences
		logger.info("Pro Exp: #{@professional_experiences.count}")
		@current_experience = @user.experiences.first
	end

	def destroy
		logger.info("Remove Experience")
		@experience = Experience.find(params[:experience_id])
		if @experience.destroy
			flash.now[:notice] = "Your work experience with #{@experience.company} has been removed"
		else
			flash.now[:error] = "There was an issue when deleting your experience. 
													Please contact us at info@complimentkarma.com"
		end
		@professional_experiences = @user.experiences
		@current_experience = @user.experiences.first
	end

	private
    def authenticate
      deny_access unless signed_in?
    end

		def set_user
			@user = User.find(params[:user_id])
		end

    def parse_date(d)
      return nil if d.blank?
      x = DateTime.strptime(d, @@date_format)
      logger.info("Date before #{d} | Date after #{x}")
      local_dt = x.new_offset
      logger.info("Local Date #{local_dt}")
      return x
    end

end
