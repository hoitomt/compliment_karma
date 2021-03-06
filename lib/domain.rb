class Domain

	def self.receiving_email
		"new@ck.mailgun.org"
	end

	def self.whitelist
		[
			'groupon.com', 'bancbox.com', 'centro.net', 'complimentkarma.com', 'searshc.com',
			'acquitygroup.com', 'us.mcd.com', 'visa.com', 'gap.com', 'cat.com', 'sanofipasteur.com',
			'ca.ibm.com', 'intuit.com', 'microstrategy.com', 'in.fujitsu.com', 'hbc.com', 'oracle.com',
			'gogoair.com', 'gspann.com', 'sap.com', 'dannon.com', 'tribune.com', 'csx.com', 'chase.com',
			'jpmc.com', 'boa.com', 'bankofamerica.com', 'artofliving.org', 'nbc.com', 'avanade.com',
			'officemax.com', 'dunkinbrands.com'
		]
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
		# puts "#{email} | #{e}"
		return false unless e.length == 2
		return from_forwarder?(e[1])
	end

	def self.master_domain?(domain)
		domain == master_domain
	end

	def self.master_domain
		"complimentkarma.com"
	end
end