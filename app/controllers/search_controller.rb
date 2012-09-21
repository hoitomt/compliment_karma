class SearchController < ApplicationController
  before_filter :set_static_vars
  
	def skills
    @search_string = params[:search_string]
    if @search_string.blank?
      @skills = nil
    else
      s = format_search_string(@search_string)
      logger.info(s)
      @skills = Skill.search do
        query { string s }
      end
      # @skills = Skill.get_autocomplete_results(@search_string)
    end
	end

	def site
    @search_string = params[:search_string]
    @source = params[:source]
    @groups = current_user.try(:groups)
    if @search_string.blank?
      @results = nil
    else
      if current_user.is_site_admin?
        @results = User.search(@search_string)
      else
        @results = User.search_with_domain(@search_string, current_user.try(:domain))
      end
    end
	end

  def compliment_receiver
    @search_string = params[:search_string]
    if @search_string.blank?
      @results = nil
    else
      if current_user.is_site_admin?
        @results = User.search(@search_string)
      else
        @results = User.search_with_domain(@search_string, current_user.try(:domain))
      end
    end
  end

	private
    def set_static_vars
      @page = (params[:page] || 1).to_i
      @per_page = 10
    end

    def format_search_string(s)
      x = s.lstrip.rstrip
      x.gsub!(/\s/, '* + *')
      return "*#{x}*"
    end
	
end
