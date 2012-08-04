class	IncomingComplimentDomain

	def self.receiving_domains
		[
			"ck.mailgun.org", "ck-prod.mailgun.org", "complimentkarma.mailgun.org",
			"ck-local.mailgun.org", "ck-dev.mailgun.org"
		]
	end

	def self.from_forwarder?(domain)
		return false if domain.blank?
		receiving_domains.include?(domain.downcase)
	end

	def self.email_from_forwarder?(email)
		e = email.split(/@/)
		puts "#{email} | #{e}"
		return false unless e.length == 2
		return from_forwarder?(e[1])
	end
end