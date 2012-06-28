module SearchHelper

	def skill_result_display(skill_name, search_string)
		len = search_string.length
		start = skill_name.downcase.index(search_string.to_s.downcase)
		stop = start + len
		result = skill_name.insert(stop, "</strong>")
		result = result.insert(start, "<strong>")
		return result.html_safe
	end


  def search_result_info(user)
    return '' if user.blank?
    if user.city || user.state_cd
      html = '<div class="search-result-info">'
      html += "<span class='user-name'>#{user.first_last}</span>"
      html += "#{user.city}" if user.city
      html += ", " if user.city && user.state_cd
      html += "#{user.state_cd}" if user.state_cd
      html += '</div>'
    else
      html = '<div class="search-result-info">'
      html += "<span class='user-name padded'>#{user.first_last}</span>"
      html += '</div>'
    end
    return html.html_safe
  end

end
