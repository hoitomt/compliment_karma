class Domain
	def self.whitelist
		['groupon.com', 'bancbox.com', 'centro.net', 'complimentkarma.com']
	end

	def self.on_whitelist?(domain)
		return false if domain.blank?
		whitelist.include?(domain.downcase)
	end
end