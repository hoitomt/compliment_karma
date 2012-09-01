# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120901023244) do

  create_table "accomplishments", :force => true do |t|
    t.string   "name"
    t.string   "image_thumb"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_mini"
    t.integer  "threshold"
  end

  create_table "account_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "action_item_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "action_items", :force => true do |t|
    t.integer  "user_id"
    t.integer  "recognition_type_id"
    t.integer  "recognition_id"
    t.integer  "action_item_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "originating_user_id"
    t.text     "note"
  end

  create_table "ck_likes", :force => true do |t|
    t.integer  "recognition_id"
    t.integer  "recognition_type_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "address_line_3"
    t.string   "city"
    t.string   "state_cd"
    t.string   "zip_cd"
    t.string   "country"
    t.string   "email"
    t.string   "url"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "industry"
    t.string   "company_type"
    t.string   "company_size"
    t.string   "operating_status"
    t.integer  "year_founded"
    t.text     "description"
  end

  create_table "company_department_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "company_department_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "company_departments", :force => true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "manager"
  end

  create_table "company_users", :force => true do |t|
    t.integer  "user_id"
    t.integer  "company_id"
    t.string   "administrator"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "compliment_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "compliment_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "list_name"
  end

  create_table "compliments", :force => true do |t|
    t.string   "sender_email"
    t.string   "receiver_email"
    t.integer  "sender_user_id"
    t.integer  "receiver_user_id"
    t.text     "comment"
    t.integer  "relation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "sender_domain"
    t.string   "receiver_domain"
    t.integer  "visibility_id"
    t.integer  "compliment_status_id"
    t.integer  "compliment_type_id"
    t.integer  "skill_id"
  end

  create_table "employment_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "experiences", :force => true do |t|
    t.string   "company"
    t.string   "title"
    t.datetime "start_date"
    t.datetime "end_date"
    t.text     "responsibilities"
    t.string   "city"
    t.string   "state_cd"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.string   "manager"
    t.integer  "employment_type_id"
  end

  create_table "follows", :force => true do |t|
    t.integer  "subject_user_id"
    t.integer  "follower_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", :force => true do |t|
    t.string   "invite_email"
    t.string   "from_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", :force => true do |t|
    t.string   "cc_holder_name"
    t.string   "cc_number"
    t.string   "cc_cvv"
    t.string   "cc_expiration_month"
    t.string   "cc_expiration_year"
    t.string   "cc_billing_address"
    t.string   "cc_billing_city"
    t.string   "cc_billing_state_cd"
    t.string   "cc_billing_zip_cd"
    t.string   "cc_card_type"
    t.string   "amount"
    t.string   "payment_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "post_offices", :force => true do |t|
    t.string   "from"
    t.string   "to"
    t.string   "cc"
    t.string   "bcc"
    t.string   "subject"
    t.text     "html"
    t.string   "attachment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recognition_comments", :force => true do |t|
    t.integer  "recognition_id"
    t.integer  "recognition_type_id"
    t.integer  "user_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "recognition_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relations", :force => true do |t|
    t.string   "name"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationship_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationships", :force => true do |t|
    t.integer  "user_1_id"
    t.integer  "user_2_id"
    t.integer  "relationship_status_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "default_visibility_id"
  end

  create_table "reward_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rewards", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "value",            :precision => 8, :scale => 2
    t.integer  "receiver_id"
    t.integer  "presenter_id"
    t.integer  "reward_status_id"
  end

  create_table "skills", :force => true do |t|
    t.string   "name"
    t.integer  "parent_skill_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "update_histories", :force => true do |t|
    t.integer  "user_id"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "update_history_type_id"
    t.integer  "recognition_type_id"
    t.integer  "recognition_id"
    t.integer  "originating_user_id"
    t.string   "read",                   :default => "false"
  end

  create_table "update_history_types", :force => true do |t|
    t.string   "name"
    t.string   "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_accomplishments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "accomplishment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_emails", :force => true do |t|
    t.integer  "user_id"
    t.string   "email"
    t.string   "domain"
    t.string   "confirmed"
    t.string   "primary_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "new_email_confirmation_token"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "founder"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.string   "register_ip"
    t.integer  "account_status_id"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "state_cd"
    t.string   "zip_cd"
    t.string   "profile_url"
    t.string   "profile_headline"
    t.integer  "industry_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "job_title"
    t.string   "domain"
    t.string   "new_account_confirmation_token"
    t.integer  "company_id"
    t.string   "country"
    t.datetime "last_read_notification_date"
    t.text     "professional_intro"
    t.text     "social_intro"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "visibilities", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
