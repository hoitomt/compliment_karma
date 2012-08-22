require 'spec_helper'

describe PagesController do
  render_views
  
  before(:each) do
    @title = "ComplimentKarma"
    controller.class.skip_before_filter :shell_authenticate
  end
  
  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
    
    it "index should have the correct title" do
      get 'index'
      response.should have_selector("title", :content => "Send Compliments, Earn Rewards | #{@title}")
    end
  end
  
  describe "GET 'invite_others'" do
    it "should be successful" do
      get 'invite_others'
      response.should be_success
    end
  end
  
  describe "GET 'invite_coworkers'" do
    it "should be successful" do
      get 'invite_coworkers'
      response.should be_success
    end
  end
  
  describe "GET 'pricing'" do
    it "should be successful" do
      get 'pricing'
      response.should be_success
    end
    
    it "should have the correct title" do
      get 'pricing'
      response.should have_selector('title', :content => "Pricing")
    end
  end
  
  describe "GET 'demo'" do
    it "should be successful" do
      get 'demo'
      response.should be_success
    end
    
    it "should have the correct title" do
      get 'demo'
      response.should have_selector('title', :content => 'Demo')
    end
  end


end
