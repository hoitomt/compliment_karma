require "spec_helper"

describe ComplimentMailer do
  let(:user){FactoryGirl.create(:user)}
  let(:user2){FactoryGirl.create(:user2)}
  let(:user3){FactoryGirl.create(:user3)}

  describe "send_compliment" do

    before(:each) do
      @compliment = Compliment.create(:skill_id => Skill.first.id,
                                      :sender_email => user2.email,
                                      :receiver_email => user3.email,
                                      :comment => "I like your sewing",
                                      :compliment_type_id => ComplimentType.PROFESSIONAL_TO_PROFESSIONAL)
    end

    it "renders the headers" do
      @compliment.sender_user_id.should eq(user2.id)
      last_email.subject.should eq("You have received a compliment")
      last_email.to.should eq([@compliment.receiver_email])
      last_email.from.should eq(['new_compliment@complimentkarma.com'])
    end

    it "renders the body" do
      last_email.body.encoded.should match("I like your sewing")
    end

    it "includes the accept and decline buttons for non-contacts" do
      action_item = ActionItem.retrieve_from_compliment(@compliment)
      action_item.should_not be_blank
      last_email.body.should include("http://test.host/email_api/accept_compliment?id=#{action_item.id}")
      last_email.body.should include("http://test.host/email_api/decline_compliment?id=#{action_item.id}")
    end

  end
  describe "compliments to existing contacts" do

    before(:each) do
      @attr = {:skill_id => Skill.first.id,
              :sender_email => user2.email,
              :receiver_email => user3.email,
              :comment => "I like your sewing",
              :compliment_type_id => ComplimentType.PROFESSIONAL_TO_PROFESSIONAL }
    end

    it "should include the view details button" do
      group_u3 = Group.get_professional_group(user3)
      Contact.create!(:user_id => user2.id, :group_id => group_u3.id)
      # user2.reload
      # user3.reload
      c = Compliment.create!(@attr)
      action_item = ActionItem.retrieve_from_compliment(c)
      action_item.should be_blank
      existing_contact = c.sender.existing_contact?(c.receiver)
      existing_contact.should_not be_blank
      last_email.body.should_not include("testing")
      last_email.body.should include("http://test.host/recognitions/1/#{c.id}")
    end
  end

end
