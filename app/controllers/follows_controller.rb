class FollowsController < ApplicationController

	def create
		subject = params[:subject_user_id]
		follower = params[:follower_user_id]
		if Follow.follow_exists?(subject, follower)
			logger.info("Delete Existing Follow")
			f = Follow.get_follow(subject, follower)
			f.delete
		else
			logger.info("Create Follow")
			f = Follow.create(:subject_user_id => subject, 
												:follower_user_id => follower)
			print_hash(f) unless f.valid?
		end

		respond_to do |format|
			format.js{ render 'create_follow' }
			format.html { redirect_to current_user }
		end
	end

	def multi_create
		f = Follow.create(:subject_user_id => params[:subject1_user_id], 
									:follower_user_id => params[:follower_user_id])
		g = Follow.create(:subject_user_id => params[:subject2_user_id], 
									:follower_user_id => params[:follower_user_id])
		print_hash(f) unless f.valid?
		print_hash(g) unless g.valid?

		respond_to do |format|
			format.js{ render 'create_follow' }
			format.html { redirect_to current_user }
		end
	end

	def print_hash(h)
		logger.info("Follow Not Created")
		msg = h.errors.messages
		msg.each do |k,v|
			logger.info("#{k}: #{v}")
		end
	end
end
