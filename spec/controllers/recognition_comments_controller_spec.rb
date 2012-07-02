require 'spec_helper'

describe RecognitionCommentsController do
  render_views
  
  let(:user2) { FactoryGirl.create(:user2)}
  let(:user3) { FactoryGirl.create(:user3)}

  before(:each) do
    controller.class.skip_before_filter :shell_authenticate
    test_sign_in(user2)
    @skill = Skill.create(:name => "Testing")
    @compliment = Compliment.create(
	    :receiver_email => user3.email,
	    :sender_email => user2.email,
	    :skill_id => @skill.id,
	    :comment => "Great Job",
      :compliment_type_id => ComplimentType.COWORKER_TO_COWORKER
    )
	  @attr = {
    	:recognition_id => @compliment.id,
    	:recognition_type_id => RecognitionType.COMPLIMENT.id,
    	:comment => "Test Case"
	  }
  end

  it 'should add the comment to the compliment' do
  	Compliment.last.receiver_user_id.should eq(user3.id)
  	lambda do
  		post :create, :recognition_comment => @attr, :format=> 'js'
  	end.should change(RecognitionComment, :count)
  end
end
