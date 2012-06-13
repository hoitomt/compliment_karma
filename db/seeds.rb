# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

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

ComplimentType.create(:name => 'Coworker to Coworker')
ComplimentType.create(:name => 'Professional to Professional (across companies)')
ComplimentType.create(:name => 'Professional to Personal')
ComplimentType.create(:name => 'Personal to Professional')
ComplimentType.create(:name => 'Personal to Personal')
  
Visibility.create(:name => 'sender and receiver')
Visibility.create(:name => 'coworkers from this job')
Visibility.create(:name => 'coworkers from all jobs')
Visibility.create(:name => 'coworkers and external contacts from this job') 
Visibility.create(:name => 'coworkers and external contacts from all jobs')
Visibility.create(:name => 'everybody')

RelationshipStatus.create(:name => 'Accepted')
RelationshipStatus.create(:name => 'Pending')
RelationshipStatus.create(:name => 'Not Accepted')

mike.account_status = AccountStatus.find_by_name('Confirmed')
mike.save

aman.account_status = AccountStatus.find_by_name('Confirmed')
aman.save

dummy.account_status= AccountStatus.find_by_name('Confirmed')
dummy.save

Reward.create(:name => '$25 Gift Card', 
              :image_thumb => 'reward/reward_thumb.png',
              :image_mini => 'reward/reward_mini.png')
Reward.create(:name => '$50 Gift Card', 
              :image_thumb => 'reward/reward_thumb.png',
              :image_mini => 'reward/reward_mini.png')
Reward.create(:name => '$75 Gift Card', 
              :image_thumb => 'reward/reward_thumb.png',
              :image_mini => 'reward/reward_mini.png')
Reward.create(:name => '$100 Gift Card', 
              :image_thumb => 'reward/reward_thumb.png',
              :image_mini => 'reward/reward_mini.png')

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

RecognitionType.create(:name => 'Compliment')
RecognitionType.create(:name => 'Reward')
RecognitionType.create(:name => 'Accomplishment')

# Compliments
UpdateHistoryType.create(:name => 'Received Compliment', :text => 'received a compliment')
UpdateHistoryType.create(:name => 'Accepted Compliment Receiver', :text => 'accepted your compliment')
UpdateHistoryType.create(:name => 'Rejected Compliment Receiver', :text => 'rejected your compliment')
UpdateHistoryType.create(:name => 'Comment on Received Compliment', :text => 'commented on received compliment')
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
UpdateHistoryType.create(:name => 'Share Accomplishment on Facebook', :text => 'shared your accomplishment on Facebook')
UpdateHistoryType.create(:name => 'Share Accomplishment on Twitter', :text => 'shared your accomplishment on Twitter')

