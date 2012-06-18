Ck::Application.routes.draw do
  root :to => "pages#index"
  
  match "follows/multi_create_new" => "follows#multi_create", :as => :multi_create_follows
  match "follows/create_new" => "follows#create_new", :as => :create_follow
  match "/signup" => "users#new"
  match "/login" => "sessions#new", :as => "login"
  match "/logout" => "sessions#destroy", :as => "logout"
  match "/pricing" => "pages#pricing"
  match "/demo" => "pages#demo"
  match "/founder_signout" => "shells#destroy"
  match "/invite_coworkers" => "pages#invite_coworkers"
  match "/invite_others" => "pages#invite_others"
  match "/search/skills" => "search#skills"
  match "/search/site" => "search#site"
  
  match "recognition/:recognition_type_id/:recognition_id" => "recognition#show", 
        :as => :show_recognition
  match "/user/:id/resend_new_account_confirmation" => "users#resend_new_account_confirmation",
        :as => :resend_new_account_confirmation
  match "/email_api/new_account_confirmation" => "email_api#new_account_confirmation",
        :as => :new_account_confirmation
  match "/email_api/invitation_acceptance" => "email_api#invitation_acceptance",
        :as => :invitation_acceptance
  match "/email_api/compliment_new_user" => "email_api#compliment_new_user",
        :as => :compliment_new_user
  match "/users/:id/get_more_karma_live_records" => "users#get_more_karma_live_records",
        :as => :get_more_karma_live_records
  match "/users/:id/accept_relationship" => "users#accept_relationship",
        :as => :accept_relationship
  match "/users/:id/decline_relationship" => "users#decline_relationship",
        :as => :decline_relationship
  match "/ck_likes/like_compliment_from_user_profile" => "ck_likes#like_compliment_from_user_profile",
        :as => :like_compliment_from_user_profile
  match "users/:id/show_recognition_detail" => "users#show_recognition_detail", 
        :as => :show_recognition_detail
  match "users/:id/dev_popup" => "users#dev_popup"
  match "users/:id/my_updates" => "users#my_updates", :as => :my_updates
  match "users/:id/professional_profile" => "users#professional_profile", 
        :as => :user_professional_profile
  match "users/:id/social_profile" => "users#social_profile", :as => :user_social_profile
  match "users/:id/received_compliments" => "users#received_compliments", 
        :as => :user_received_compliments
  match "users/:id/sent_compliments" => "users#sent_compliments", 
        :as => :user_sent_compliments
  match "users/:id/achievements" => "users#achievements", :as => :user_achievements
  match "users/:id/contacts" => "users#contacts", :as => :user_contacts
  match "users/:id/settings" => "users#settings", :as => :user_settings
  match "users/:id/upload_photo" => "users#upload_photo", :as => :upload_photo

  resources :follows
  resources :recognition_comments, :only => [:create]
  resources :ck_likes, :only => [:new, :create]
  resources :accomplishments
  resources :rewards  
  resources :relations
  resources :compliments
  resources :users
  resources :invitations
  resources :sessions, :only => [:new, :create, :destroy]
  resources :shells, :only => [:new, :create, :destroy]
  resources :password_resets
  

end
