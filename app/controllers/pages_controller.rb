class PagesController < ApplicationController
  def index
    @title = "Welcome"
    @invitation = Invitation.new
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

  def learn
    @title = "Learn"
  end

  def search
    
  end

end
