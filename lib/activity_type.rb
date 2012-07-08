class ActivityType

	attr_accessor :id, :name

	def initialize(id, name)
		self.id = id
		self.name = name
	end

	def self.list
		return [ compliments_received, compliments_sent ]
		# return [ compliments_received, compliments_sent, trophies_earned, badges_earned ]
	end

	def self.find(id)
		list.each do |atype|
			return atype if atype.id.to_i == id.to_i
		end
		return nil
	end

	def self.compliments_received
		return ActivityType.new(1, 'Compliments Received')		
	end

	def self.compliments_sent
		return ActivityType.new(2, 'Compliments Sent')
	end

	def self.trophies_earned
		return ActivityType.new(3, 'Trophies Earned')
	end

	def self.badges_earned
		return ActivityType.new(4, 'Badges Earned')
	end

end