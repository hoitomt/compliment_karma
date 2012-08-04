class Domain
	def self.whitelist
		['groupon.com', 'bancbox.com', 'centro.net', 'complimentkarma.com']
	end

	def self.on_whitelist?(domain)
		return false if domain.blank?
		whitelist.include?(domain.downcase)
	end

	def self.email_on_whitelist?(email)
		e = email.split(/@/)
		return false unless e.length == 2
		return on_whitelist?(e[1])
	end
end