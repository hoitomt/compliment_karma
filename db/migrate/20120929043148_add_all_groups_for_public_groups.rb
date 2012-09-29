class AddAllGroupsForPublicGroups < ActiveRecord::Migration
  def change
  	User.all.each do |u|
  		pg = Group.get_professional_group(u)
  		pg.attach_to_all_groups
  		sg = Group.get_social_group(u)
  		sg.attach_to_all_groups
  	end
  end

end
