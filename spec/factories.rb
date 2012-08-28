FactoryGirl.define do
  factory :user, class: User do
    name "Guest User"
    email "factory_user@testing.com"
    password "foobarz"
    domain "testing.com"
    account_status_id 2
  end

  factory :user2, class: User do
    name "Guest User"
    email "factory_user2@complimentkarma.com"
    password "foobary"
    domain "complimentkarma.com"
    account_status_id 2
  end

  factory :user3, class: User do
    name "Another User"
    email "factory_user3@complimentkarma.com"
    password "foobarx"
    domain "complimentkarma.com"
    account_status_id 2
  end
  
  factory :unconfirmed_user, class: User do
    name "Unconfirmed User"
    email "unconfirmed_user@complimentkarma.com"
    password "foobar"
    domain "complimentkarma.com"
    account_status_id 1
  end

  factory :unconfirmed_user2, class: User do
    name "Unconfirmed User2"
    email "unconfirmed_user2@complimentkarma.com"
    password "foobar"
    domain "complimentkarma.com"
    account_status_id 1
  end
  
  factory :unconfirmed_user3, class: User do
    name "Unconfirmed User3"
    email "unconfirmed_user3@simpsons.com"
    password "foobar"
    domain "complimentkarma.com"
    account_status_id 1
  end
  
  factory :founder, class: User do
    name "Guest User"
    email "founder@complimentkarma.com"
    password "foobar"
    domain "complimentkarma.com"
    founder true
  end

  factory :sears_user, class: User do
    name "Another User"
    email "factory_user3@searshc.com"
    password "foobar"
    domain "searshc.com"
    account_status_id 2
  end

  factory :groupon_user, class: User do
    name "Another User"
    email "factory_user3@groupon.com"
    password "foobar"
    domain "groupon.com"
    account_status_id 2
  end

  factory :invitation, class: Invitation do
    invite_email "invited_user@complimentkarma.com"
    from_email "nonfounder@complimentkarma.com"
  end

  factory :skill, class: Skill do
    name "testing"
    parent_skill_id 1
  end
  
end

# FactoryGirl.define :compliment do |f|
#   f.sender_email user2.email
#   f.receiver_email user3.email
#   f.comment "Ima test comment"
#   f.compliment_type_id compliment_id
#   f.suppress_fulfillment true
#   f.sequence(:skill_id){ |n| Skill.create("name #{n}").id }
# end

