require 'spec_helper'

describe ContactsController do
	render_views

	let(:user2){ FactoryGirl.create(:user2) }
  let(:user3){ FactoryGirl.create(:user3) }

  before(:each) do
    @new_title = "Sign up"
    controller.class.skip_before_filter :shell_authenticate
    @user2 = FactoryGirl.create(:user2)
    @user3 = FactoryGirl.create(:user3)
    @user2.groups.count.should == 5
    @user3.groups.count.should == 5
    test_sign_in(@user2)
  end

  describe "POST 'create'" do
  	before(:each) do
  		# @attr = {
  		# 	:group_id => @user2.groups.first,
  		# 	:contact_user_id => @user3.id
  		# }
      @attr = {
        :user_id => @user2.id,
        :contact_user_id => @user3.id,
        :groups => {@user2.groups.first.id => "yes"},
      }
  	end

  	it "should create new contact" do
  		lambda do
	  		post :create, @attr.merge(:format => 'js')
	  	end.should change(Contact, :count).by(1)
  	end

  	it "should add user as new contact" do
      post :create, @attr.merge(:format => 'js')
  		@user3.memberships.count.should == 1
  		@user2.contacts.count.should == 1
  		@user2.contacts.first.group.group_type.should == @user2.groups.first.group_type
  	end

  	it "should not create a duplicate contact" do
      post :create, @attr.merge(:format => 'js')
  		@user3.memberships.count.should == 1
      post :create, @attr.merge(:format => 'js')
  		@user3.memberships.count.should == 1
  		@user2.contacts.count.should_not == 2
  	end

    it "should not add a user to their own group" do
      lambda do
        post :create, @attr.merge(:contact_user_id => @user2.id, :format => 'js')
      end.should_not change(Contact, :count)
    end

  end

  # @user2 is signed in
  describe "Add and Remove Contact" do
    before(:each) do
      @attr = {
        :group_id => @user2.groups.first,
        :user_id => @user3.id
      }
      @user2.groups.each do |g|
        @social_group = g if g.social?
        @professional_group = g if g.professional?
        @declined_group = g if g.declined?
      end
    end

    it "should add the contacts" do
      # c_pro = Contact.create(:group_id => @professional_group.id, :user_id => @user3.id)
      # c_soc = Contact.create(:group_id => @social_group.id, :user_id => @user3.id)
      post :add_remove_contact, :user_id => @user2.id,
                                :contact_group => {@social_group.id.to_s => "yes", 
                                                   @professional_group.id.to_s => "yes"},
                                :contact_user_id => @user3.id
      @user2.contacts.count.should == 2
    end

    it "should remove a contact" do
      post :add_remove_contact, :user_id => @user2.id,
                                :contact_group => {@social_group.id.to_s => "yes", 
                                                   @professional_group.id.to_s => "yes"},
                                :contact_user_id => @user3.id
      @user2.reload
      @user2.contacts.count.should == 2

      post :add_remove_contact, :user_id => @user2.id,
                                :contact_group => {@professional_group.id.to_s => "yes"},
                                :contact_user_id => @user3.id
      @user2.reload
      @user2.contacts.count.should == 1
    end

    it "should not remove the last contact" do
      post :add_remove_contact, :user_id => @user2.id,
                                :contact_group => {@professional_group.id.to_s => "yes"},
                                :contact_user_id => @user3.id
      @user2.reload
      @user2.contacts.count.should == 1

      post :add_remove_contact, :user_id => @user2.id,
                                :contact_group => {@professional_group.id.to_s => "yes"},
                                :contact_user_id => @user3.id
      @user2.reload
      @user2.contacts.count.should == 1
    end

    it "should not blow up on null group_id" do
      post :add_remove_contact, :user_id => @user2.id,
                                :group_id => nil,
                                :contact_user_id => @user3.id
      @user2.reload
      @user2.contacts.count.should == 0

      post :add_remove_contact, :user_id => @user2.id,
                                :contact_group => {@professional_group.id.to_s => "yes"},
                                :contact_user_id => @user3.id
      @user2.reload
      @user2.contacts.count.should == 1
    end

    it "should not blow up on null contact_id" do
      post :add_remove_contact, :user_id => @user2.id,
                                :contact_group => {@social_group.id.to_s => "yes"},
                                :contact_user_id => nil
      @user2.reload
      @user2.contacts.count.should == 0

      post :add_remove_contact, :user_id => @user2.id,
                                :contact_group => {@professional_group.id.to_s => "yes"},
                                :contact_user_id => @user3.id
      @user2.reload
      @user2.contacts.count.should == 1
    end

  end

  describe "Decline a contact" do
    before(:each) do
      @attr = {
        :group_id => @user2.groups.first,
        :user_id => @user3.id
      }
      @user2.groups.each do |g|
        @social_group = g if g.social?
        @professional_group = g if g.professional?
        @declined_group = g if g.declined?
      end
    end

    it "should delete the contact" do
      post :add_remove_contact, :user_id => @user2.id,
                                :contact_group => {@social_group.id.to_s => "yes"},
                                :contact_user_id => @user3.id
      u = User.find(@user2.id)
      u.contacts.count.should == 1

      post :decline, :user_id => @user2.id,
                     :id => @user2.contacts.last
      @user2.reload
      @user2.contacts.count.should == 0
    end


    it "should delete only one of the group affiliations" do
      post :add_remove_contact, :user_id => @user2.id,
                                :contact_group => {@social_group.id.to_s => "yes",
                                                   @professional_group.id.to_s => "yes"},
                                :contact_user_id => @user3.id
      @user2.reload
      @user2.contacts.count.should == 2
      group = @user2.contacts.first.group

      post :decline, :user_id => @user2.id,
                     :id => @user2.contacts.last
      @user2.reload
      @user2.contacts.count.should == 0
    end

  end

end
