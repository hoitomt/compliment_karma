Ck::Application.routes.draw do
  root :to => "pages#index"
  
  match 'mailer(/:action(/:id(.:format)))' => 'mailer#:action'
  match "follows/multi_create_new" => "follows#multi_create", :as => :multi_create_follows
  match "follows/create_new" => "follows#create_new", :as => :create_follow
  match "/signup" => "users#new"
  match "/login" => "sessions#new", :as => "login"
  match "/logout" => "sessions#destroy", :as => "logout"
  match "/pricing" => "pages#pricing"
  match "/demo" => "pages#demo"
  match "/learn" => "pages#learn"
  match "/about" => "pages#about"
  match "/bad_words" => "pages#bad_words"
  match "/team" => "pages#team"
  match "/guidelines" => "pages#guidelines"
  match "/help" => "pages#help"
  match "/contact" => "pages#contact"
  match "/founder_signout" => "shells#destroy"
  match "/invite_coworkers" => "pages#invite_coworkers"
  match "/invite_others" => "pages#invite_others"
  match "/admin" => "admin#index", :as => :admin
  
  match "compliments/set_compliment_types" => "compliments#set_compliment_types"
  match "/email_api/new_account_confirmation" => "email_api#new_account_confirmation",
        :as => :new_account_confirmation
  match "/email_api/new_email_confirmation" => "email_api#new_email_confirmation",
        :as => :new_email_confirmation
  match "/email_api/invitation_acceptance" => "email_api#invitation_acceptance",
        :as => :invitation_acceptance
  match "/email_api/compliment_new" => "email_api#compliment_new",
        :as => :compliment_new_user
  match "/recognition/:recognition_type_id/:recognition_id" => "recognition#show", 
        :as => :show_recognition
  match "/relationships/:id/accept" => "relationships#accept", :as => :accept_relationship
  match "/relationships/:id/decline" => "relationships#decline", :as => :decline_relationship
  match "/rewards/add_to_cart" => "rewards#add_to_cart"
  match "/rewards/filter_rewards_results" => "rewards#filter_rewards_results"
  match "/rewards/cart" => "rewards#cart", :as => :cart
  match "/rewards/checkout" => "rewards#checkout", :as => :checkout
  match "/rewards/remove_from_cart" => "rewards#remove_from_cart", :as => :remove_from_cart
  match "/search/skills" => "search#skills"
  match "/search/site" => "search#site"
  match "/search/compliment_receiver" => "search#compliment_receiver"
  match "/ck_likes/like_compliment_from_user_profile" => "ck_likes#like_compliment_from_user_profile",
        :as => :like_compliment_from_user_profile
  match "users/:id/dev_popup" => "users#dev_popup"
  match "users/:id/facebook" => "users#facebook", :as => :user_facebook
  match "users/:id/get_more_karma_live_records" => "users#get_more_karma_live_records",
        :as => :get_more_karma_live_records
  match "users/:id/my_updates" => "users#my_updates", :as => :my_updates
  match "users/:id/my_updates_all" => "users#my_updates_all", :as => :my_updates_all
  match "users/:id/professional_profile" => "users#professional_profile", 
        :as => :user_professional_profile
  match "users/:id/resend_new_account_confirmation" => "users#resend_new_account_confirmation",
        :as => :resend_new_account_confirmation
  match "users/:id/show_recognition_detail" => "users#show_recognition_detail", 
        :as => :show_recognition_detail
  match "users/:id/switch_accounts" => "users#switch_accounts", :as => :switch_accounts
  match "users/:id/edit_from_profile" => "users#edit_from_profile", :as => :edit_from_profile
  match "users/:id/upload_photo" => "users#upload_photo", :as => :upload_photo

  ## User Menu Routes
  match "users/:id/achievements" => "users#achievements", :as => :user_achievements
  match "users/:id/contacts" => "users#contacts", :as => :user_contacts
  match "users/:id/settings" => "users#settings", :as => :user_settings
  match "users/:id/privacy" => "users#privacy", :as => :user_privacy
  match "users/:id/employees" => "users#employees", :as => :user_employees
  match "users/:id/rewards" => "users#rewards", :as => :user_rewards
  match "users/:id/received_compliments" => "users#received_compliments", 
        :as => :user_received_compliments
  match "users/:id/sent_compliments" => "users#sent_compliments", 
        :as => :user_sent_compliments
  match "users/:id/social_profile" => "users#social_profile", :as => :user_social_profile

  match "users/:user_id/action_items/:id/pre_accept" => "action_items#pre_accept", 
        :as => :pre_accept_action_item
  match "users/:user_id/action_items/:id/accept" => "action_items#accept", 
        :as => :accept_action_item
  match "users/:user_id/action_items/:id/decline" => "action_items#decline", 
        :as => :decline_action_item
  match "users/:user_id/user_emails/set_primary_email" => "user_emails#set_primary_email", 
        :as => :set_primary_email
  match "users/:user_id/user_emails/:id/resend_email_confirmation" => "user_emails#resend_email_confirmation",
        :as => :resend_email_confirmation

  match "users/:id/filter_contacts" => "users#filter_contacts", :as => :user_filter_contacts
  match "users/:user_id/contacts/add_remove_contact" => "contacts#add_remove_contact",
        :as => :add_remove_contact
  match "users/:user_id/contacts/create_contact" => "contacts#create", :as => :create_contact
  match "users/:user_id/contacts/:id/decline" => "contacts#decline",
        :as => :decline_contact
        

  # Metrics
  match "compliments/count" => "compliments#count"

  resources :follows
  resources :recognition_comments, :only => [:create]
  resources :ck_likes, :only => [:new, :create]
  resources :accomplishments
  resources :rewards  
  resources :relations
  resources :compliments
  resources :users do
    resources :action_items
    resources :contacts
    resources :groups
    resources :user_emails
  end
  resources :invitations
  resources :sessions, :only => [:new, :create, :destroy]
  resources :shells, :only => [:new, :create, :destroy]
  resources :password_resets
  resources :payments
  resources :experiences
  resources :company_department_users
  resources :company_departments
  resources :company_users
  resources :companies

end
