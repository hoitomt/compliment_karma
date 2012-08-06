class PaymentsController < ApplicationController
	before_filter :authenticate
	before_filter :get_user

	def new
		if session[:cart].blank?
			flash[:error] = "Your cart does not contain any items"
			redirect_to :back
		else
			@cart_total = session[:cart].inject(0){ |sum, r_id| sum + Reward.find(r_id).value }
			@service_fee = @cart_total.to_f * 0.08 + 1
			@order_total = @cart_total.to_f + @service_fee.to_f
			@payment = Payment.new
		end
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
