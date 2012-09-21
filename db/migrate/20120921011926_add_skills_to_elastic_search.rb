class AddSkillsToElasticSearch < ActiveRecord::Migration
  def change
  	Skill.index.import Skill.all
  end
end
