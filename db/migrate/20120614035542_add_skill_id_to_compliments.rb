class AddSkillIdToCompliments < ActiveRecord::Migration
  def change
    add_column :compliments, :skill_id, :integer
  end
end
