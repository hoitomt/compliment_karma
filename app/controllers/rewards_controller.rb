class RewardsController < ApplicationController
	def add_to_cart
		@user = User.find(params[:company_user_id])
		rewards = params[:reward]
		reward_created = false
		if rewards
			session[:cart] ||= []
			rewards.each do |k, v|
				r = Reward.new(:value => v, 
											 :receiver_id => k, 
											 :presenter_id => @user.id, 
											 :reward_status_id => RewardStatus.pending.id)
				if r.save
					reward_created = true
					session[:cart] << r.id
				end
			end
		end
		unless reward_created
			logger.info("Error creating reward")
			flash.now[:error] = "Please specify a valid reward amount for at least one of the employees"
		end
		respond_to do |format|
			format.html { redirect_to @user }
			format.js {  }
		end
	end

	def remove_from_cart
		logger.info("Session Cart: #{session[:cart].to_s}")
		session[:cart].delete(params[:reward_id].to_i)
		flash[:notice] = "Item has been removed from cart"
		redirect_to cart_path(:user_id => params[:user_id])
	end

	def checkout
		@user = User.find(params[:user_id])
		if session[:cart].blank?
			flash[:error] = "Your cart is empty"
			redirect_to user_rewards_path(@user)
		else
			redirect_to cart_path(:user_id => @user.id)
		end
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
