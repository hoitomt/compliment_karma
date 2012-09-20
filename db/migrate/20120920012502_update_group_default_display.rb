class UpdateGroupDefaultDisplay < ActiveRecord::Migration
  def up
  	Group.all.each do |g|
    	if g.professional? || g.social?
    		g.update_attributes(:display => 'Y')
    	end
    end
  end

  def down
  end
end
