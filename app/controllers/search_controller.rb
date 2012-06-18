class SearchController < ApplicationController

	def skills
    @search_string = params[:search_string]
    @skills = Skill.get_autocomplete_results(@search_string)
	end

	def site
    @search_string = params[:search_string]
    @results = User.search(@search_string)
	end
	
end
