require 'spec_helper'

def login_user(user)
  visit login_path
  fill_in "Email", :with => user.email
  fill_in "Password", :with => user.password
  click_button('Log In')
  page.should have_selector('title', :content => user.first_last )
end

describe "Notifications" do

  describe "update history" do

    before(:each) do
      @user2 = FactoryGirl.create(:user2)
      @user3 = FactoryGirl.create(:user3)
      @c_attr = {
        :receiver_email => @user3.email,
        :sender_email => @user2.email,
        :skill_id => Skill.first.id,
        :comment => "I love what you did with our application",
        :compliment_type_id => ComplimentType.PROFESSIONAL_TO_PROFESSIONAL
      }
      login_user(@user2)
    end

    it "should create a compliment" do
      lambda do
        Compliment.create(@c_attr)
      end.should change(Compliment, :count).by(1)
    end

    it "should display the accomplishment notifications" do
      c = Compliment.create(@c_attr)
      a = @user2.accomplishments
      a.count.should == 1
      u = UpdateHistory.find_all_by_user_id(@user2.id)
      u.count.should == 1
      visit "/users/#{@user2.id}/my_updates_all"
      # get my_updates_all_url(:id => @user2.id)
      # save_and_open_page
      page.should have_content("#{@user2.first_last} earned a #{a.first.name} badge")
    end

    it "should display the ck_like compliment notifications" do
      # Create the compliment
      c = Compliment.create(@c_attr)
      a = @user2.accomplishments
      a.count.should == 1
      
      # Create the ck_like on the compliment by visiting the receivers's page and liking the compliment
      visit "/users/#{@user3.id}"
      page.should have_content("I love what you did with our application")
      click_link "Like"

      visit logout_path
      login_user(@user3)
      
      u = UpdateHistory.find_all_by_user_id(@user3.id)
      u.count.should == 2
      
      visit "/users/#{@user3.id}/my_updates_all"
      page.should have_content("#{@user2.first_last} liked your compliment from #{@user2.first_last}")
    end

    it "should display the ck_like accomplishment notifications" do
      visit logout_path
      # Create the compliment
      c = Compliment.create(@c_attr)
      a = @user2.accomplishments
      a.count.should == 1
      
      login_user(@user3)
      # Create the ck_like on the compliment by visiting the receivers's page and liking the compliment
      visit "/users/#{@user2.id}"
      page.should have_content("I love what you did with our application")
      page.should have_content("Earned a #{a.first.name} badge by sending their First compliment")
      within("li.orange") do
        click_link "Like"
      end

      visit logout_path
      login_user(@user2)
      
      u = UpdateHistory.find_all_by_user_id(@user2.id)
      u.count.should == 2
      
      visit "/users/#{@user2.id}/my_updates_all"
      page.should have_content("#{@user3.first_last} liked your #{a.first.name} badge")
    end

  end

end