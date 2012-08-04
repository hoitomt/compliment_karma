class PagesController < ApplicationController
  before_filter :hide_search_bar

  def index
    @title = "Send Compliments, Earn Rewards | ComplimentKarma"
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

  def about
  end

  def team
  end

  def guidelines
  end

  def contact
  end

  def help
  end

  def bad_words
    @words = Blacklist.words
  end

  private

    def hide_search_bar
      @hide_search_bar = true
    end

end
