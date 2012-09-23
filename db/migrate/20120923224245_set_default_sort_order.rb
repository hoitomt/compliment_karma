class SetDefaultSortOrder < ActiveRecord::Migration
  def up
    users = User.all
    users.each do |u|
    	groups = u.groups
    	groups.each do |g|
    		sort_o = Group.define_sort_order(g.name)
        g.update_attributes(:sort_order => sort_o)
    	end
    end
  end

  def down
  end
end
