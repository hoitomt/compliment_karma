class UpdateGroupDefaultDisplay2 < ActiveRecord::Migration
  def change
  	Group.all.each do |g|
    	if g.professional? || g.social?
    		g.update_attributes(:display_ind => 'Y')
    	end
    end
  end
end
