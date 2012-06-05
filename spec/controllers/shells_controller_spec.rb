require 'spec_helper'

describe ShellsController do
  render_views
  
  describe "GET 'index'" do
    it "should be successful" do
      get :new
      response.should be_success
    end
    
    it "should have the correct title" do
      get :new
      response.should have_selector("title", :content => "Sign in")
    end
  end

end
