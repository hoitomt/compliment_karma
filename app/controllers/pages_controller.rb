class PagesController < ApplicationController
  def index
    @title = "Welcome"
    flash.each do |k,v|
      if(v.class == Compliment)
        logger.info("Flash Compliment: #{k}: #{v}")
        v.attributes.each do |field, value|
          logger.info("Flash Compliment Values: #{field}: #{value}")
        end
      else
        logger.info("Flash: #{k}: #{v}")
      end
    end
    @compliment = Compliment.new
    if flash[:compliment]
      @compliment = Compliment.new(flash[:compliment].attributes)
      flash[:compliment].errors.each do |attr, msg|
        @compliment.errors.add(attr, msg)
      end
      @compliment.errors.full_messages.each do |msg|
        logger.info("Error: #{msg}")
      end
    end
    flash.delete(:compliment)
    if current_user
      redirect_to current_user
    end
  end
  
  def invite_coworkers
    @title = "Invite Coworkers"
    @invitation = Invitation.new
  end
  
  def invite_others
    @title = "Invite Others"
    @invitation = Invitation.new
  end
  
  def pricing
    @title = "Pricing"
  end
  
  def demo
    @title = "Demo"
  end

  def search_skills
    @search_string = params[:search_string]
    @skills = Skill.get_autocomplete_results(@search_string)
  end

end
