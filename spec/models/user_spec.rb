require 'spec_helper'

describe User do
  before(:each) do
    @attr = { 
      :name => "Example User", 
      :email => "user@example.com",
      :password => "foobar"
     }
  end
  
  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end
  
  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end
  
  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |a|
      valid_email_user = User.new(@attr.merge(:email => a))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |a|
      invalid_email_user = User.new(@attr.merge(:email => a))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  it "should parse the name" do
    User.create!(@attr.merge(:name => "Three Part Name"))
    u = User.last
    u.first_name = "Three"
    u.middle_name = "Part"
    u.last_name = "Name"
  end
  
  it "should parse the domain name" do
    User.create!(@attr.merge(:email => "test@example.org"))
    u = User.last
    u.domain = "example.org"
  end
  
  describe "password validations" do
    
    it "should require a password" do
      User.new(@attr.merge(:password => "")).should_not be_valid
    end
    
    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short)
      User.new(hash).should_not be_valid
    end
    
    it "should reject long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long)
      User.new(hash).should_not be_valid
    end
  end
  
  describe "password encryption" do
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end
    
    it "should set the encrypted password" do
      @user.encrypted_password.should_not be_blank
    end
    
    describe "has_password? method" do
      
      it "should be true if the passwords match" do
        @user.has_password?(@attr[:password]).should be_true
      end
      
      it "should be false if the passwords do not match" do
        @user.has_password?("invalid").should be_false
      end
    end
    
    describe "authenticate method" do
      
      it "should return nil on email/password mismatch" do
        wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
        wrong_password_user.should be_nil
      end
      
      it "should return nil for an email address with no user" do
        nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
        nonexistent_user.should be_nil
      end
      
      it "should return the user on email/password match" do
        matching_user = User.authenticate(@attr[:email], @attr[:password])
        matching_user.should == @user
      end

    end
    
    describe "send_password_reset" do
      
      let(:user) { FactoryGirl.create(:user) }
      
      it "should generate a unique password_reset_token each time" do
        user.send_password_reset
        last_token = user.password_reset_token
        user.send_password_reset
        user.password_reset_token.should_not eq(last_token)
      end
      
      it "should save the time the password reset was sent" do
        user.send_password_reset
        user.reload.password_reset_sent_at.should be_present
      end
      
      it "should deliver email to user" do
        user.send_password_reset
        last_email.to.should include (user.email)
      end
    end
  end
  
  describe "outbound confirmation email upon user creation" do
      
    it "should generate a unique confirmation token" do
      p = User.create!(@attr.merge(:email => "joe6pack@example.org"))
      p.send_account_confirmation
      last_token = p.new_account_confirmation_token
      u = User.create!(@attr)
      u.send_account_confirmation
      u.new_account_confirmation_token.should_not eq(last_token)
    end
    
    it "should deliver the email to the user" do
      u = User.create!(@attr)
      u.send_account_confirmation
      last_email.to.should include (u.email)
    end
  end
  
  describe "account status" do    
    it "should create unconfirmed users" do
      u = User.create!(@attr)
      u.account_status.should eq(AccountStatus.UNCONFIRMED)
    end
  end

  describe "company adminstrator" do
    let(:company_admin){User.find_by_email('mike@complimentkarma.com')}
    let(:company){Company.find_by_name('ComplimentKarma')}

    it 'should get a user' do
      company_admin.should_not be_nil
    end

    it "should get a company" do
      company.should_not be_nil
    end

    it "should be the administrator of the company" do
      admin = company_admin.is_company_administrator?(company.id)
      admin.should be_true
    end

  end
  
end
