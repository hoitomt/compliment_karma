class RelationshipsController < ApplicationController
	before_filter :authenticate

	def accept
		relationship = Relationship.find(params[:id])
		relationship.accept_relationship
		redirect_to current_user
	end

	def decline
		relationship = Relationship.find(params[:id])
	  relationship.decline_relationship
	  redirect_to current_user
	end

	private
	
    def authenticate
      deny_access unless signed_in?
    end

end
