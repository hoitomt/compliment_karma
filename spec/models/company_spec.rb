require 'spec_helper'

describe Company do
	let(:company) {Company.find_by_name('ComplimentKarma')}
	let(:user) {FactoryGirl.create(:user)}

	it "should return a company" do
		company.should_not be_nil
	end

  describe "add an employee to the company" do
  	before(:each) do
  		@company_user = CompanyUser.create(:company_id => company.id, :user_id => user.id)
  	end

  	it "should create the company_user" do
  		@company_user.should_not be_nil
  	end

  	it "should create the follow for the company" do
  		f = Follow.find_by_subject_user_id(user.id)
  		f.follower_user_id.should eq(company.user.id)
  	end

  	it "should create an approved relationship" do
  		r = Relationship.find_by_user_2_id(user.id)
  		r.should_not be_nil
  		r.user_1_id.should eq(company.user.id)
  		r.user_2_id.should eq(user.id)
  		r.relationship_status_id.should eq(RelationshipStatus.ACCEPTED.id)
  	end

	end
end
