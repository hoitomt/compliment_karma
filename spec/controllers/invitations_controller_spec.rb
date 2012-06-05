require 'spec_helper'

describe InvitationsController do
  render_views
  
  before(:each) do
    controller.class.skip_before_filter :shell_authenticate
  end
  
  describe "POST create" do
    describe "failure" do
      before(:each) do
        @attr = {:invite_email => "", :from_email => ""}
      end
      
      it "should not create an invitation" do
        lambda do
          post :create, :invitation => @attr
        end.should_not change(Invitation, :count)
      end
      
    end
    
    describe "success" do
      before(:each) do
        u = FactoryGirl.create(:user)
        test_sign_in(u)
        @attr = {:invite_email => "invite_me@example.org", :from_email => "imatest@example.org"}
      end
      
      it "should create an invitation" do
        lambda do
          post :create, :invitation => @attr
        end.should change(Invitation, :count)
      end
      
      it "should create multiple invitations" do
        params = {:email1 =>"test@example.org", :email2 => "testing@example.org", :email3 =>"",
                  :email4=>"", :email5=>"", :email6=>""}
        lambda do
          post :create, :multi_invitation => params
        end.should change(Invitation, :count).by(2)
      end
      
      it "should create multiple invitations with missing domain" do
        params = {:email1 =>"test_nodomain", :email2 => "testing_nodomain", :email3 =>"",
                  :email4=>"", :email5=>"", :email6=>""}
        lambda do
          post :create, :multi_invitation => params
        end.should change(Invitation, :count).by(2)
      end
      
      it "should not send multiple invitations to the same person in the same request" do
        params = {:email1 =>"test_nodomain", :email2 => "test_nodomain", :email3 =>"",
                  :email4=>"", :email5=>"", :email6=>""}
        lambda do
          post :create, :multi_invitation => params
        end.should_not change(Invitation, :count).by(2)
      end
      
    end
  end
end
