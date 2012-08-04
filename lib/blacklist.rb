class Blacklist
	def self.words
		['fuck', 'shit', 'sex', 'xxx', 'butt', 'boob', 'penis', 'dick', 'cock']
	end

	def self.valid?(string)
		words.each do |w|
			return false if string =~ Regexp.new(w)
		end
		return true
	end

end