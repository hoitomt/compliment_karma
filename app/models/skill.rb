class Skill < ActiveRecord::Base

	validates :name, :presence => true

  validates_uniqueness_of :name, :scope => [:parent_skill_id],
                          :message => "This skill already exists"

	# returns a hash of {k,v} => {parent name, skill name}
	def self.list_for_autocomplete
		skills = Skill.where('id <> parent_skill_id')
		parents = Skill.parent_skills
		a = skills.collect{|skill| autocomplete_key(skill, parents) }
		return a
	end

	def self.parent_skills
		parents = Skill.where('id = parent_skill_id').select('id, name')
		return Hash[ parents.map{ |skill| [skill.id, skill.name] } ]
	end

	def self.autocomplete_key(skill, parents)
		"#{parents[skill.parent_skill_id]}#{key_separator}#{skill.name}"
	end

	def parent_skill_key
		parent = Skill.find_by_id(self.parent_skill_id)
		return "#{parent.name}#{Skill.key_separator}#{self.name}"
	end

	def self.key_separator
		return ' - '
	end

	def self.get_autocomplete_results(search_string)
		return if search_string.nil?
		results = Skill.where('name like ? AND id <> parent_skill_id', "%#{search_string.downcase}%").limit(10)
		# results = []
		# list_for_autocomplete.each do |autocomplete_key|
		# 	results << autocomplete_key if autocomplete_key.downcase.include?(search_string.downcase)
		# 	break if results.size > 10
		# end
		# return results
	end

	def self.get_skill_by_autocomplete_key(autocomplete_key)
		split = autocomplete_key.split(key_separator)
		parent_skill_id = Skill.where('name = ? AND id = parent_skill_id', split[0])[0]
		skill = Skill.where('name = ? AND parent_skill_id = ?', split[1], parent_skill_id)[0]
	end

	def self.USER_DEFINED
		Skill.find_by_name('User Defined')
	end

end
