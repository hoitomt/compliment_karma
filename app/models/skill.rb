class Skill < ActiveRecord::Base

	# returns a hash of {k,v} => {parent name, skill name}
	def self.list_for_autocomplete
		skills = Skill.where('id <> parent_skill_id')
		parents = Skill.parent_skills
		a = skills.collect{|skill| "#{parents[skill.parent_skill_id]} - #{skill.name}"}
		# hash = Hash[ skills.map{ |skill| [ skill.id, [parents[skill.parent_skill_id],skill.name ] ]} ]
		return a
	end

	def self.parent_skills
		parents = Skill.where('id = parent_skill_id').select('id, name')
		return Hash[ parents.map{ |skill| [skill.id, skill.name] } ]
	end

end
