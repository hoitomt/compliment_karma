require 'spec_helper'

describe "LayoutLinks" do

  describe "Public URLs" do
    it "should GET home page should be a success" do
      visit '/'
      current_path.should == root_path
    end

    it "should GET about page should be a success" do
      visit '/about'
      current_path.should == about_path
    end

    it "should GET team page should be a success" do
      visit '/team'
      current_path.should == team_path
    end

    it "should GET guidelines page should be a success" do
      visit '/guidelines'
      current_path.should == guidelines_path
    end

    it "should GET contact page should be a success" do
      visit '/contact'
      current_path.should == contact_path
    end

    it "should GET help page should be a success" do
      visit '/help'
      current_path.should == help_path
    end

    it "should GET login page should be a success" do
      visit '/login'
      current_path.should == login_path
    end

    it "should GET home page should be a success" do
      visit '/signup'
      current_path.should == signup_path
    end
  end

  describe "Home Page Links" do
    before(:each) do
      visit '/'
    end

    it "should return login" do
      click_link 'Log In'
      current_path.should == login_path
    end

    it "should return sign up" do
      click_link 'Sign Up'
      current_path.should == signup_path
    end
  end

  describe "About Page Links" do
    before(:each) do
      visit '/about'
    end

    it "should GET about page should be a success" do
      visit '/team'
      click_link 'About'
      current_path.should == about_path
    end

    it "should GET team page should be a success" do
      click_link 'Team'
      current_path.should == team_path
    end

    it "should GET guidelines page should be a success" do
      click_link 'Guidelines'
      current_path.should == guidelines_path
    end

    it "should GET contact page should be a success" do
      click_link 'Contact'
      current_path.should == contact_path
    end

    it "should GET help page should be a success" do
      click_link 'Help'
      current_path.should == help_path
    end
  end

  describe "User Profile Links Compliment Not Required" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      visit login_path
      fill_in "Email", :with => @user.email
      fill_in "Password", :with => @user.password
      click_button ("Log In")
      page.should have_selector('title', :content => "Profile")
    end

    it "should GET Professional Profile" do
      click_link 'Professional Profile'
      page.should have_content('Professional Experience')
    end

    it "should GET Social Profile" do
      click_link 'Social Profile'
      page.should have_content('Achievements by Skill')
    end
  end

  describe "User Profile Links Compliment Required" do
    let(:user2) {FactoryGirl.create(:user2)}
    let(:user3) {FactoryGirl.create(:user3)}

    before(:each) do
      visit login_path
      fill_in "Email", :with => user2.email
      fill_in "Password", :with => user2.password
      click_button ("Log In")
      page.should have_selector('title', :content => "Profile")
    end

    describe "Received Compliment" do
      before :each do
        @attr = {
          :receiver_email => user2.email,
          :sender_email => user3.email,
          :skill_id => Skill.first.id,
          :comment => "I love what you did with our application",
          :compliment_type_id => ComplimentType.PROFESSIONAL_TO_PROFESSIONAL
        }
        @compliment = Compliment.create(@attr)
      end

      it "should GET Received Compliments" do
        click_link 'Received Compliments'
        page.should have_content('Date')
      end
    end

    describe "Sent Compliment" do
      before :each do
        @attr = {
          :receiver_email => user3.email,
          :sender_email => user2.email,
          :skill_id => Skill.first.id,
          :comment => "I love what you did with our application",
          :compliment_type_id => ComplimentType.PROFESSIONAL_TO_PROFESSIONAL
        }
        @compliment = Compliment.create(@attr)
      end

      it "should GET Sent Compliments" do
        click_link 'Sent Compliments'
        # save_and_open_page
        page.should have_content('Date')
      end
    end
  end
  
end
