class CreateGroupsForUsers < ActiveRecord::Migration
  def up
  	TaskRunner.create_more_groups_and_relationships
  end

  def down
  end
end
