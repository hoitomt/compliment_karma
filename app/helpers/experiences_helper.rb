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
		if exp.end_date.blank?
			end_date = DateTime.now
		else
			end_date = exp.end_date
		end
		year_diff = end_date.year - exp.start_date.year 
		month_diff = 0
		if exp.start_date.month > end_date.month
			month_diff = 12 - (exp.start_date.month - end_date.month)
		else
			month_diff = end_date.month - exp.start_date.month
		end

			end_date.month - exp.start_date.month



		if month_diff > 24
			return "#{month_diff / 12} years #{month_diff % 12} months"
		elsif month_diff > 12
			return "1 year #{month_diff % 12} months"
		elsif month_diff == 12
			return "1 year"
		elsif month_diff > 1
			return "#{month_diff} months"
		else
			return "1 month"
		end
	end

	def display_responsibilities(resp)
		return if resp.blank?
		r = resp.gsub(/\r\n/, "<br />")
		return r.html_safe
	end
end
