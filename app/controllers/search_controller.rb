class SearchController < ApplicationController
  before_filter :set_static_vars
  
	def skills
		@popup = params[:popup] || 'false'
    @search_string = params[:search_string]
    @skills = Skill.get_autocomplete_results(@search_string)
	end

	def site
    @search_string = params[:search_string]
    @results = User.search(@search_string)
	end

	private
    def set_static_vars
      @page = (params[:page] || 1).to_i
      @per_page = 10
    end
	
end
