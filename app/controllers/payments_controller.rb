class PaymentsController < ApplicationController
	before_filter :authenticate
	before_filter :get_user

	def new
		@payment = Payment.new
	end

	def create
		@payment = Payment.new(params[:payment])
	end

	private

    def authenticate
      deny_access unless signed_in?
    end

    def get_user
      @user = current_user
      redirect_to(root_path) unless @user
    end
end
