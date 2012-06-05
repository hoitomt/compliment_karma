require 'spec_helper'

describe CkLike do
	let(:user) {FactoryGirl.create(:user)}
	let(:user2){FactoryGirl.create(:user2)}
	let(:user3){FactoryGirl.create(:user3)}

  before(:each) do
  	@compliment = Compliment.create(:skill => "Testing",
  																	:sender_email => user2.email,
  																	:receiver_email => user3.email,
  																	:comment => "Great job testing",
  																	:compliment_type_id => ComplimentType.COWORKER_TO_COWORKER)
    @attr = { 
    	:recognition_id => @compliment.id,
    	:recognition_type_id => RecognitionType.COMPLIMENT.id,
    	:user_id => user.id
     }
  end

  
end
