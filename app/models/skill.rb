class Skill < ActiveRecord::Base

	validates :name, :presence => true

  validates_uniqueness_of :name,
                          :message => "This skill already exists"

  before_create :remove_naughty_words

  def remove_naughty_words
  	self.name = Blacklist.clean_string(self.name)
  end

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
		results = Skill.where('lower(name) like ? AND id <> parent_skill_id', 
													"%#{search_string.downcase}%").limit(10)
	end

	def self.get_skill_by_autocomplete_key(autocomplete_key)
		split = autocomplete_key.split(key_separator)
		parent_skill_id = Skill.where('name = ? AND id = parent_skill_id', split[0])[0]
		skill = Skill.where('name = ? AND parent_skill_id = ?', split[1], parent_skill_id)[0]
	end

	def self.USER_DEFINED
		Skill.find_by_name('User Defined')
	end
	
	def self.UNDEFINED
		return Skill.find_by_name('Undefined')
	end

	def self.find_or_create_skill(skill_id, skill_text)
		if skill_id.blank?
			s = Skill.where('lower(name) = ?', skill_text.downcase).first
			s = Skill.create(:name => skill_text, :parent_skill_id => Skill.USER_DEFINED.id) if s.blank?
			return s
		else
			return Skill.find(skill_id)
		end
	end

	def self.matches_compliment_type?(skill_name)
		return false if skill_name.blank?
		ComplimentType.all.each do |type|
			logger.info "Matching: #{type.name} | #{skill_name}"
			return true if type.name.downcase == skill_name.downcase
		end
		return false
	end
	
end
