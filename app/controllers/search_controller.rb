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

	def site
    @search_string = params[:search_string]
    if @search_string.blank?
      @results = nil
    else
      @results = User.search(@search_string)
    end
	end

  def compliment_receiver
    @search_string = params[:search_string]
    if @search_string.blank?
      @results = nil
    else
      @results = User.search(@search_string)
    end
  end

	private
    def set_static_vars
      @page = (params[:page] || 1).to_i
      @per_page = 10
    end
	
end
