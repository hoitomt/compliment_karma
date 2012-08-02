module ExperiencesHelper
	def date_range(exp)
		if exp.start_date && exp.end_date
			start_date = exp.start_date.strftime("%b %Y")
			end_date = exp.end_date.strftime("%b %Y")
			return "#{start_date} to #{end_date}"
		elsif exp.start_date
			start_date = exp.start_date.strftime("%b %Y")
			return "#{start_date} to Present"
		else
			return ""
		end
	end

	def date_math(exp)
		return "" if exp.start_date.blank?
		start_date = exp.start_date
		if exp.end_date.blank?
			end_date = DateTime.now
		else
			end_date = exp.end_date
		end

		year_diff = end_date.year - start_date.year 
		month_diff = 0
		if start_date.month > end_date.month
			month_diff = year_diff * 12 - (start_date.month - end_date.month)
			# month_diff = 12 - (start_date.month - end_date.month)
		else
			month_diff = year_diff * 12 + (end_date.month - start_date.month)
		end

		end_date.month - start_date.month
		logger.info("Year Diff: #{year_diff}, Month Diff: #{month_diff}")
		if month_diff > 23
			return "#{year_diff} years #{month_display(month_diff)}"
		elsif month_diff > 12
			return "1 year #{month_display(month_diff)}"
		elsif month_diff == 12
			return "1 year"
		elsif month_diff > 1
			return "#{month_display(month_diff)}"
		else
			return "1 month"
		end
	end

	def month_display(m)
		diff = m % 12
		if diff > 1
			return "#{diff} months"
		elsif diff == 1
			return "1 month"
		else
			return ""
		end
	end

	def display_responsibilities(resp)
		return if resp.blank?
		r = resp.gsub(/\r\n/, "<br />")
		return r.html_safe
	end
end
