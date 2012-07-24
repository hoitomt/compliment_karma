class RewardsController < ApplicationController

	# This handles both add to cart and checkout.
	# An html request is a checkout request
	# A Javascript request is an add to cart request
	def add_to_cart
		@user = User.find(params[:company_user_id])
		rewards = params[:reward]
		reward_created = add_reward_to_cart(rewards)
		respond_to do |format|
			format.html {
				if session[:cart].blank?
					flash[:error] = "Your cart is empty"
					redirect_to user_rewards_path(@user)
				elsif @user.blank?
					redirect_to root_path
				else
					if reward_created == 1
						flash[:notice] = "1 new reward has been created"
					elsif reward_created > 1
						flash[:notice] = "#{reward_created} new rewards have been created"
					end
					redirect_to cart_path(:user_id => @user.id)
				end
			}
			format.js { 
				unless reward_created > 0
					logger.info("Error creating reward")
					flash.now[:error] = "Please specify a valid reward amount for at least one of the employees"
				else
					if reward_created == 1
						flash.now[:notice] = "1 new reward has been added to the cart"
					else
						flash.now[:notice] = "#{reward_created} new rewards have been added to the cart"
					end
				end
			}
		end
	end

	def remove_from_cart
		logger.info("Session Cart: #{session[:cart].to_s}")
		session[:cart].delete(params[:reward_id].to_i)
		flash[:notice] = "Item has been removed from cart"
		redirect_to cart_path(:user_id => params[:user_id])
	end

	def checkout
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
				h = {}
				reward = Reward.find(reward_id)
				h[:reward] = reward
				h[:employee] = reward.receiver
				@rewards << h
			end
		end
	end

	private
		def add_reward_to_cart(rewards)
			return if @user.blank? || rewards.blank?
			reward_created = 0
			session[:cart] ||= []
			rewards.each do |k, v|
				r = Reward.new(:value => v, 
											 :receiver_id => k, 
											 :presenter_id => @user.id, 
											 :reward_status_id => RewardStatus.pending.id)
				if r.save
					reward_created += 1
					session[:cart] << r.id
				end
			end
			return reward_created
		end
end
