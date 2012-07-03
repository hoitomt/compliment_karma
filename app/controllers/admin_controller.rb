class AdminController < ApplicationController
  before_filter :authenticate
  before_filter :customer_admin_user, :except => [:rewards]
  before_filter :set_admin_flag

	def index
	end

	def rewards
	end

  def users
  end

	def settings		
	end

	private

    def authenticate
      deny_access unless signed_in?
      @user = User.find(params[:company_user_id])
    end

    def customer_admin_user
      deny_access unless customer_admin_user?
    end

    def set_admin_flag
      @admin = customer_admin_user?
    end
end
