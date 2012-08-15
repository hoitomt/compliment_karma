class SearchController < ApplicationController
  before_filter :set_static_vars
  
	def skills
    @search_string = params[:search_string]
    if @search_string.blank?
      @skills = nil
    else
      @skills = Skill.get_autocomplete_results(@search_string)
    end
	end

  # def skills
  #   @search_string = params[:search_string]
  #   skill_array = []
  #   if @search_string.blank?
  #     # @skills = nil
  #     @skills = Skill.first(10)
  #     h = {}
  #     @skills.each { |skill| h[skill.id] = skill.name }
  #   else
  #     @skills = Skill.get_autocomplete_results(@search_string)
  #   end
  #   respond_to do |format|
  #     format.js { render :json => h.to_json}
  #   end
  #   # render :nothing => true
  # end

	def site
    @search_string = params[:search_string]
    if @search_string.blank?
      @results = nil
    else
      @results = User.search_with_domain(@search_string, current_user.try(:domain))
    end
	end

  def compliment_receiver
    @search_string = params[:search_string]
    if @search_string.blank?
      @results = nil
    else
      @results = User.search_with_domain(@search_string, current_user.try(:domain))
    end
  end

	private
    def set_static_vars
      @page = (params[:page] || 1).to_i
      @per_page = 10
    end
	
end
