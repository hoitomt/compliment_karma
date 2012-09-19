# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Relations
Relation.create(:name => 'Coworker', :category => 'Internal')
Relation.create(:name => 'Client', :category => 'External')
Relation.create(:name => 'Business Partner', :category => 'External')
Relation.create(:name => 'Service Provider', :category => 'External')

AccountStatus.create(:name => 'Unconfirmed') if AccountStatus.find_by_name('Unconfirmed').nil?
AccountStatus.create(:name => 'Confirmed') if AccountStatus.find_by_name('Confirmed').nil?
AccountStatus.create(:name => 'Terminated') if AccountStatus.find_by_name('Terminated').nil?

ComplimentStatus.create(:name => 'Pending Receiver Registration')
ComplimentStatus.create(:name => 'Pending Receiver Confirmation')
ComplimentStatus.create(:name => 'Active')
ComplimentStatus.create(:name => 'Withdrawn')

RewardStatus.create(:name => 'Pending')
RewardStatus.create(:name => 'Complete')

# ComplimentType.create(:name => 'Coworker to Coworker')
ComplimentType.create(:name => "Professional to Professional", 
                      :list_name => "from my PROFESSIONAL to receivers PROFESSIONAL profile")
ComplimentType.create(:name => "Professional to Social", 
                      :list_name => "from my PROFESSIONAL to receivers SOCIAL profile")
ComplimentType.create(:name => "Social to Professional", 
                      :list_name => "from my SOCIAL to receivers PROFESSIONAL profile")
ComplimentType.create(:name => "Social to Social", 
                      :list_name => "from my SOCIAL to receivers SOCIAL profile")
c = ComplimentType.PROFESSIONAL_TO_PROFESSIONAL
c.update_attributes(:sender_type => 'Professional', :receiver_type => 'Professional')
c = ComplimentType.PROFESSIONAL_TO_PERSONAL
c.update_attributes(:sender_type => 'Professional', :receiver_type => 'Social')
c = ComplimentType.PERSONAL_TO_PROFESSIONAL
c.update_attributes(:sender_type => 'Social', :receiver_type => 'Professional')
c = ComplimentType.PERSONAL_TO_PERSONAL
c.update_attributes(:sender_type => 'Social', :receiver_type => 'Social')
  
Visibility.create(:name => 'sender and receiver')
Visibility.create(:name => 'coworkers from this job')
Visibility.create(:name => 'coworkers from all jobs')
Visibility.create(:name => 'coworkers and external contacts from this job') 
Visibility.create(:name => 'coworkers and external contacts from all jobs')
Visibility.create(:name => 'everybody')

RelationshipStatus.create(:name => 'Accepted')
RelationshipStatus.create(:name => 'Pending')
RelationshipStatus.create(:name => 'Not Accepted')

Accomplishment.create(:name => 'Gold Trophy', 
                      :threshold => 500,
                      :image_thumb => 'accomplishment/trophy_thumb.png',
                      :image_mini => 'accomplishment/trophy_mini.png')
Accomplishment.create(:name => 'Aspirant Badge',
                      :threshold => 30,
                      :image_thumb => 'accomplishment/Badge_Aspirant.png',
                      :image_mini => 'accomplishment/badge_mini.png')
Accomplishment.create(:name => 'Ninja Badge',
                      :threshold => 100,
                      :image_thumb => 'accomplishment/Badge_Ninja.png',
                      :image_mini => 'accomplishment/badge_mini.png')
Accomplishment.create(:name => 'Master Badge',
                      :threshold => 300,
                      :image_thumb => 'accomplishment/Badge_Master.png',
                      :image_mini => 'accomplishment/badge_mini.png')
Accomplishment.create(:name => 'Grand Master Badge',
                      :threshold => 500,
                      :image_thumb => 'accomplishment/Badge_Grand_Master.png',
                      :image_mini => 'accomplishment/badge_mini.png')
Accomplishment.create(:name => 'Level 1 Complimenter',
                      :threshold => 1,
                      :image_thumb => 'accomplishment/Badge_Complimenter_1.png',
                      :image_mini => 'accomplishment/badge_mini.png')
Accomplishment.create(:name => 'Level 2 Complimenter',
                      :threshold => 50,
                      :image_thumb => 'accomplishment/Badge_Complimenter_2.png',
                      :image_mini => 'accomplishment/badge_mini.png')
Accomplishment.create(:name => 'Level 3 Complimenter',
                      :threshold => 200,
                      :image_thumb => 'accomplishment/Badge_Complimenter_3.png',
                      :image_mini => 'accomplishment/badge_mini.png')
Accomplishment.create(:name => 'Level 4 Complimenter',
                      :threshold => 500,
                      :image_thumb => 'accomplishment/Badge_Complimenter_4.png',
                      :image_mini => 'accomplishment/badge_mini.png')
Accomplishment.create(:name => 'Level 5 Complimenter',
                      :threshold => 1000,
                      :image_thumb => 'accomplishment/Badge_Complimenter_5.png',
                      :image_mini => 'accomplishment/badge_mini.png')
Accomplishment.create(:name => 'Level 1 Rewarder',
                      :threshold => 100,
                      :image_thumb => 'accomplishment/Badge_Rewarder_1.png',
                      :image_mini => 'accomplishment/badge_mini.png')
Accomplishment.create(:name => 'Level 2 Rewarder',
                      :threshold => 1000,
                      :image_thumb => 'accomplishment/Badge_Rewarder_2.png',
                      :image_mini => 'accomplishment/badge_mini.png')
Accomplishment.create(:name => 'Level 3 Rewarder',
                      :threshold => 5000,
                      :image_thumb => 'accomplishment/Badge_Rewarder_3.png',
                      :image_mini => 'accomplishment/badge_mini.png')
Accomplishment.create(:name => 'Level 4 Rewarder',
                      :threshold => 50000,
                      :image_thumb => 'accomplishment/Badge_Rewarder_4.png',
                      :image_mini => 'accomplishment/badge_mini.png')
Accomplishment.create(:name => 'Level 5 Rewarder',
                      :threshold => 100000,
                      :image_thumb => 'accomplishment/Badge_Rewarder_5.png',
                      :image_mini => 'accomplishment/badge_mini.png')

ActionItemType.create(:name => 'Authorize Compliment')

RecognitionType.create(:name => 'Compliment')
RecognitionType.create(:name => 'Reward')
RecognitionType.create(:name => 'Accomplishment')

GroupType.create(:name => "Professional")
GroupType.create(:name => "Social")
GroupType.create(:name => "Declined")

# Compliments
UpdateHistoryType.create(:name => 'Received Compliment', :text => 'received a compliment')
UpdateHistoryType.create(:name => 'Accepted Compliment Receiver', :text => 'accepted your compliment')
UpdateHistoryType.create(:name => 'Rejected Compliment Receiver', :text => 'rejected your compliment')
UpdateHistoryType.create(:name => 'Comment on Received Compliment', 
  :text => 'commented on received compliment')
UpdateHistoryType.create(:name => 'Comment on Sent Compliment', :text => 'commented on sent compliment')
UpdateHistoryType.create(:name => 'Like Received Compliment', :text => 'liked a received compliment')
UpdateHistoryType.create(:name => 'Like Sent Compliment', :text => 'liked a sent compliment')
UpdateHistoryType.create(:name => 'Share Received Compliment On Facebook', 
                         :text => 'shared a received compliment on Facebook')
UpdateHistoryType.create(:name => 'Share Sent Compliment On Facebook', 
                         :text => 'shared a sent compliment on Facebook')
UpdateHistoryType.create(:name => 'Share Received Compliment On Twitter', 
                         :text => 'shared a received compliment on Twitter')
UpdateHistoryType.create(:name => 'Share Sent Compliment On Twitter', 
                         :text => 'shared a sent compliment on Twitter')
# Follows
UpdateHistoryType.create(:name => 'Following You', :text => 'is following you')
# Rewards
UpdateHistoryType.create(:name => 'Received Reward', :text => 'rewarded')
UpdateHistoryType.create(:name => 'Comment on Reward', :text => 'commented on your reward')
UpdateHistoryType.create(:name => 'Like Reward', :text => 'liked your reward')
UpdateHistoryType.create(:name => 'Share Reward on Facebook', :text => 'shared your reward on Facebook')
UpdateHistoryType.create(:name => 'Share Reward on Twitter', :text => 'shared your reward on Twitter')
# Accomplishments
UpdateHistoryType.create(:name => 'Earned an Accomplishment', :text => 'earned an')
UpdateHistoryType.create(:name => 'Comment on Accomplishment', :text => 'commented on your accomplishment')
UpdateHistoryType.create(:name => 'Like Accomplishment', :text => 'liked your accomplishment')
UpdateHistoryType.create(:name => 'Share Accomplishment on Facebook', 
  :text => 'shared your accomplishment on Facebook')
UpdateHistoryType.create(:name => 'Share Accomplishment on Twitter', 
  :text => 'shared your accomplishment on Twitter')

EmploymentType.create(:name => "Employee")
EmploymentType.create(:name => "Contractor")
EmploymentType.create(:name => "Intern")

if Skill.find_by_name('User Defined').nil?
  s = Skill.create(:name => 'User Defined')
  s.update_attributes(:parent_skill_id => s.id)
end
if Skill.find_by_name('Undefined').nil?
  s = Skill.create(:name => 'Undefined')
  s.update_attributes(:parent_skill_id => s.id)
end

mike = User.find_by_email("mike@hoitomt.com")
mike_attr = {:email => "mike@hoitomt.com", 
                :name => "Mike Hoitomt", 
                :password => "w1sco kid 33",
                :first_name => "Mike",
                :last_name => "Hoitomt",
                :domain => "hoitomt.com"}
if mike.nil?
  mike = User.new(mike_attr)
  mike.founder = "Y"
  mike.save
else
  mike.update_attributes(mike_attr)
end

mike_ck = User.find_by_email("mike@complimentkarma.com")
mike_ck_attr = {:email => "mike@complimentkarma.com", 
                :name => "Michael Hoitomt", 
                :password => "w1sco kid 33"}
if mike_ck.nil?
  mike_ck = User.new(mike_ck_attr)
  mike_ck.save
else
  mike_ck.update_attributes(mike_ck_attr)
end

aman = User.find_by_email("rewardtheproductive@gmail.com")
aman_attr = { :email => "rewardtheproductive@gmail.com", 
                   :name => "Guramandeep Singh", 
                   :password => "ch1 town 41",
                   :first_name => "Guramandeep",
                   :last_name => "Singh",
                   :domain => "gmail.com" }
if aman.nil?  
  aman = User.new( aman_attr )
  aman.founder = "Y"
  aman.save
else
  aman.update_attributes(aman_attr)
end

aman_ck = User.find_by_email("aman@complimentkarma.com")
aman_ck_attr = {:email => "aman@complimentkarma.com", 
                :name => "Aman Singh", 
                :password => "ch1 town 41"}
if aman_ck.nil?
  aman_ck = User.new(aman_ck_attr)
  aman_ck.save
else
  aman_ck.update_attributes(aman_ck_attr)
end

dummy = User.find_by_email("dummy@example.org")
dummy_attr = { :email => "dummy@example.org", 
                   :name => "Dummy User", 
                   :password => "dummy user",
                   :first_name => "Dummy",
                   :last_name => "User",
                   :domain => "example.org" }
if dummy.nil?  
  dummy = User.new( dummy_attr )
  dummy.save
else
  dummy.update_attributes(dummy_attr)
end

ck = Company.find_by_name("ComplimentKarma")
ck_attr = {
  :name => "ComplimentKarma",
  :address_line_1 => '1316 White Pine Dr',
  :city => 'Eau Claire',
  :state_cd => 'WI',
  :zip_cd => '54701',
  :country => 'USA',
  :email => 'info@complimentkarma.com',
  :url => 'www.complimentkarma.com',
  :phone => '(715) 225-2563'
}
if ck.nil?
  ck = Company.create(ck_attr)
else
  ck.update_attributes(ck_attr)
end

CompanyDepartment.create(:name => 'Human Resources', :company_id => ck.id)
CompanyDepartment.create(:name => 'Engineering', :company_id => ck.id)
CompanyDepartment.create(:name => 'Marketing', :company_id => ck.id)

ck_user = User.find_by_email("info@complimentkarma.com")
ck_user_attr = {:email => "info@complimentkarma.com", 
                :name => "ComplimentKarma", 
                :password => "ck 33 wi il",
                :company_id => ck.id,
                :account_status_id => 2 }
if ck_user.nil?
  ck_user = User.create(ck_user_attr)
else
  ck_user.update_attributes(ck_user_attr)
end

mike_c_ck = CompanyUser.find_by_user_id(mike_ck.id)
if mike_c_ck.blank?
  mike_c_ck = CompanyUser.create(:user_id => mike_ck.id, 
                                     :company_id => ck.id,
                                     :administrator => "true")
end

aman_c_ck = CompanyUser.find_by_user_id(aman_ck.id)
if aman_c_ck.blank?
  aman_c_ck = CompanyUser.create(:user_id => aman_ck.id, 
                                          :company_id => ck.id,
                                          :administrator => "true")
end

mike.account_status = AccountStatus.find_by_name('Confirmed')
mike.save

aman.account_status = AccountStatus.find_by_name('Confirmed')
aman.save

dummy.account_status= AccountStatus.find_by_name('Confirmed')
dummy.save