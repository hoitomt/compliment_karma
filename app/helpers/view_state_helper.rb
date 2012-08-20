module ViewStateHelper
  # possible states:
  # 1. user managing their own page
  # 2. user viewing somebody else's page
  # 3. user viewing a company's page
  # 4. user managing somebody else's page
  # @user is the page being viewed

  def view_state(user)
    if user.nil?
      return view_state_user_visitor
  	elsif user.is_a_company?
  		if current_user?(user)
  			return view_state_company_manager
  		else
  			return view_state_company_visitor
  		end
  	else
  		if current_user?(user)
  			return view_state_user_manager
  		else
  			return view_state_user_visitor
  		end
  	end
  end

  def view_state_user_manager
  	return "User Manager"
  end

  def view_state_user_visitor
  	return "User Visitor"
  end

  def view_state_company_manager
  	return "Company Manager"
  end

  def view_state_company_visitor
  	return "Company Visitor"
  end

  def page_owner?(user)
    return false if user.blank?
    return view_state(user) == view_state_company_manager ||
           view_state(user) == view_state_user_manager
  end

end