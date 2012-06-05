require 'spec_helper'

describe Follow do
	let(:user){FactoryGirl.create(:user)}
	let(:user2){FactoryGirl.create(:user2)}

	it "should not allow you to follow yourself" do
		f = Follow.new(:subject_user_id => user.id, :follower_user_id => user.id)
		f.should_not be_valid
	end
end
