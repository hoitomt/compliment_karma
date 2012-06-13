class SkillsSandbox

	def self.parse_list
		# a = []
		parent = nil
		parent_skill = nil
		parents = []
		File.open("#{Rails.root}/lib/Skills.csv", 'rt') do |f|
			File.open("#{Rails.root}/lib/Skills_new.txt", 'w') do |new_line|
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
					# child = k[1].strip!.nil? ? parent : k[1]
					# new_line.write "#{parent},#{child}\n"

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