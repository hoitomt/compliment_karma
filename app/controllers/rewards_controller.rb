class RewardsController < ApplicationController
	def add_to_cart
		@user = User.find(params[:company_user_id])
		rewards = params[:reward]
		if rewards
			session[:cart] ||= []
			rewards.each do |k, v|
				r = Reward.new(:value => v, 
											 :receiver_id => k, 
											 :presenter_id => @user.id, 
											 :reward_status_id => RewardStatus.pending.id)
				if r.save
					session[:cart] << r.id
				end
			end
		end

	end

	def remove_from_cart
		logger.info("Session Cart: #{session[:cart].to_s}")
		session[:cart].delete(params[:reward_id].to_i)
		flash[:notice] = "Item has been removed from cart"
		redirect_to cart_path(:user_id => params[:user_id])
	end

	def cart
		@user = User.find(params[:user_id])
		@rewards = []
		unless session[:cart].blank?
			session[:cart].each do |reward_id|
				@rewards << Reward.find(reward_id)
			end
		end
	end
end
