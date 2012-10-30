require 'spec_helper'

describe Accomplishment do
  let(:user2){FactoryGirl.create(:user2)}
  let(:user3){FactoryGirl.create(:user3)}

  before(:each) do
    @attr = {
      :receiver_email => user3.email,
      :sender_email => user2.email,
      :skill_id => Skill.first.id,
      :comment => "I love what you did with our application",
      :compliment_type_id => ComplimentType.PROFESSIONAL_TO_PROFESSIONAL
    }
  end

  it "should create an accomplishment for the sender" do
    Compliment.create(@attr)
    user2.accomplishments.length.should == 1
  end

  it "should create an update history based on the accomplishment" do
    Compliment.create(@attr)
    uh = UpdateHistory.where(:update_history_type_id => UpdateHistoryType.Earned_an_Accomplishment.id,
                             :user_id => user2.id)
    uh.length.should == 1
  end

  it "should create two recognitions" do
    lambda do
      Compliment.create(@attr)
    end.should change(Recognition, :count).by(2)
    c = UserAccomplishment.last
    t = RecognitionType.ACCOMPLISHMENT
    r = Recognition.find_by_type_and_id(t.id, c.id)
    r.should_not be_blank
  end

end