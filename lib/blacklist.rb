class Blacklist

	def self.valid?(string)
		words.each do |w|
			return false if string =~ Regexp.new(w)
		end
		return true
	end

	def self.clean_string(s)
		s = s.gsub(words, '')
	end

	def self.words
		bad_words = BadWords.list.collect{ |word| "(#{word})" }
		# r = "\\b(#{ bad_words.join('|') })\\b"
		Regexp.new("\\b(#{ bad_words.join('|') })\\b")
	end

end