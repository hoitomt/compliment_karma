class RemoveSkillFromCompliments < ActiveRecord::Migration
  def up
  	remove_column :compliments, :skill
  end

  def down
    add_column :compliments, :skill_id, :integer
  end
end
