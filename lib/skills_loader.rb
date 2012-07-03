class SkillsLoader

	def self.parse_list
		parent_skill_name = 'ComplimentKarma'
		parent_skill = Skill.find_by_name(parent_skill_name)
		if parent_skill.blank?
			parent_skill = Skill.create(:name => parent_skill_name)
			parent_skill.update_attributes(:parent_skill_id => parent_skill.id)
		end
		File.open("#{Rails.root}/lib/Skills.csv", 'rt') do |f|
			while line = f.gets
				child = nil
				line.gsub!(/@/, '')
				line.gsub!(/\"/, '')
				child = line.strip
				child_skill = Skill.find_all_by_name(child)
				if child_skill.blank?
					child_skill = Skill.create(:name => child, :parent_skill_id => parent_skill.id)
				end
			end
		end
	end

	def self.parse_list_with_parent
		# a = []
		parent = nil
		parent_skill = nil
		parents = []
		File.open("#{Rails.root}/lib/Skills.csv", 'rt') do |f|
			while line = f.gets
				child = nil
				line.gsub!(/@/, '')
				line.gsub!(/\"/, '')
				# a << line
				k = line.split(/,/)
				if k[0].size > 0
					parent = k[0]
					parents << parent
					parent_skill = Skill.find_by_name(parent)
					if parent_skill.blank?
						parent_skill = Skill.create(:name => parent)
						parent_skill.update_attributes(:parent_skill_id => parent_skill.id)
					end
				end
				if k[1].strip.blank?
					child = parent.strip
				else
					child = k[1].strip
					child_skill = Skill.find_all_by_name(child)
					if child_skill.blank?
						child_skill = Skill.create(:name => child, :parent_skill_id => parent_skill.id)
					else
						create_new = true
						child_skill.each do |c|
							if c.parent_skill_id == parent_skill.id
								create_new = false
								break
							end
						end
						child_skill = Skill.create(:name => child, :parent_skill_id => parent_skill.id) if create_new
					end
				end
			end
		end
		File.open("#{Rails.root}/lib/Parents.txt", 'w') do |p_file|
			parents.each do |skill|
				p_file.write "#{skill}\n"
			end
		end
	end

end