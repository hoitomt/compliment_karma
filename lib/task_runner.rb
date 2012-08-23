class TaskRunner

	# Update compliment types 20120822
	def self.run_task
		c = ComplimentType.all
		c[0].update_attributes(:name => "Professional to Professional", 
													 :list_name => "from my PROFESSIONAL to receivers PROFESSIONAL profile")
		c[1].update_attributes(:name => "Professional to Social", 
													 :list_name => "from my PROFESSIONAL to receivers SOCIAL profile")
		c[2].update_attributes(:name => "Social to Professional", 
													 :list_name => "from my SOCIAL to receivers PROFESSIONAL profile")
		c[3].update_attributes(:name => "Social to Social", 
													 :list_name => "from my SOCIAL to receivers SOCIAL profile")
	end
end