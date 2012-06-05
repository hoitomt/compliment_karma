require "spec_helper"

describe ComplimentMailer do
  let(:user){FactoryGirl.create(:user)}
  let(:user2){FactoryGirl.create(:user2)}
  let(:user3){FactoryGirl.create(:user3)}

  before(:each) do
    @compliment = Compliment.create(:skill => "Sewing",
                                    :sender_email => user.email,
                                    :receiver_email => user3.email,
                                    :comment => "I like your sewing",
                                    :compliment_type_id => ComplimentType.COWORKER_TO_COWORKER)
  end

  describe "send_compliment" do

    it "renders the headers" do
      c = Compliment.last
      c.sender_user_id.should eq(user.id)
      last_email.subject.should eq("You have received a compliment")
      last_email.to.should eq([@compliment.receiver_email])
      last_email.from.should eq(['no-reply@complimentkarma.com'])
    end

    it "renders the body" do
      last_email.body.encoded.should match("I like your sewing")
    end
  end

end
