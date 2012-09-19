class MigrateComplimentTypesToTags < ActiveRecord::Migration
  def up
  	Compliment.all.each do |c|
  		c.create_tags
  	end
  end

  def down
  end
end
