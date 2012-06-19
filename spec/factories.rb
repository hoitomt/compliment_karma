FactoryGirl.define do
  factory :user, class: User do
    name "Guest User"
    email "factory_user@testing.com"
    password "foobar"
    domain "testing.com"
    account_status_id 2
  end

  factory :user2, class: User do
    name "Guest User"
    email "factory_user2@example.com"
    password "foobar"
    domain "example.com"
    account_status_id 2
  end

  factory :user3, class: User do
    name "Another User"
    email "factory_user3@example.com"
    password "foobar"
    domain "example.com"
    account_status_id 2
  end
  
  factory :unconfirmed_user, class: User do
    name "Unconfirmed User"
    email "unconfirmed_user@example.com"
    password "foobar"
    domain "example.com"
    account_status_id 1
  end

  factory :unconfirmed_user2, class: User do
    name "Unconfirmed User2"
    email "unconfirmed_user2@example.com"
    password "foobar"
    domain "example.com"
    account_status_id 1
  end
  
  factory :unconfirmed_user3, class: User do
    name "Unconfirmed User3"
    email "unconfirmed_user3@simpsons.com"
    password "foobar"
    domain "example.com"
    account_status_id 1
  end
  
  factory :founder, class: User do
    name "Guest User"
    email "founder@example.com"
    password "foobar"
    domain "example.com"
    founder true
  end

  factory :invitation, class: Invitation do
    invite_email "invited_user@example.com"
    from_email "nonfounder@example.com"
  end
end
