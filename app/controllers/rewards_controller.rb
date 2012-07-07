class RewardsController < ApplicationController
	def add_to_cart
		@user = User.find(params[:company_user_id])
		rewards = params[:reward]
		if rewards
			session[:cart] ||= []
			rewards.each do |k, v|
				r = Reward.new(:value => v, :receiver_id => k, :presenter_id => @user.id)
				if r.valid?
					session[:cart] << r
				end
			end
		end

	end

	def cart
		@user = User.find(params[:user_id])
		@rewards = session[:cart]
	end
end
