class Skill < ActiveRecord::Base

	# returns a hash of {k,v} => {parent name, skill name}
	def self.list_for_autocomplete
		skills = Skill.where('id <> parent_skill_id')
		parents = Skill.parent_skills
		a = skills.collect{|skill| autocomplete_key(skill, parents) }
		# hash = Hash[ skills.map{ |skill| [ skill.id, [parents[skill.parent_skill_id],skill.name ] ]} ]
		return a
	end

	def self.parent_skills
		parents = Skill.where('id = parent_skill_id').select('id, name')
		return Hash[ parents.map{ |skill| [skill.id, skill.name] } ]
	end

	def self.autocomplete_key(skill, parents)
		"#{parents[skill.parent_skill_id]} - #{skill.name}"
	end

	def self.get_autocomplete_results(search_string)
		results = []
		list_for_autocomplete.each do |autocomplete_key|
			results << autocomplete_key if autocomplete_key.include?(search_string)
			break if results.size > 10
		end
		return results
	end

end
