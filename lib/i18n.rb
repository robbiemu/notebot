# encoding: utf-8

# README !!
#	Like all i18n libraries, this package provides one-way translation
#	consistency. Natural languages do not. UNLIKE most i18n libraries,
# 	this package furthermore provides TWO-WAY translation consistency
# 	through lang_of(<keyword>, :from => :<language_tag>) so that 
# 	I18n.lang_of("excomulgar", {:from => :en}) must produce :es where
#	I18n.t("ban", {:to => :es}) produces "excomulgar"

module I18n
	class << self
		@@default_language = nil
		@@dictionaries = {}
		@@reverse_dictionaries = {}
				
		def _dictionaries()
			return @@dictionaries
		end

		def _reverse_dictionaries()
			return @@reverse_dictionaries
		end
		
		def default_language()
			return @@default_language
		end
		
		def default_language=(arg)
			@@default_language = arg
		end

		def add_dictionary(key, dict)
			@@dictionaries[key] = dict
			dict.keys.each do |k|
				if not @@reverse_dictionaries.key?( dict[k] )
					@@reverse_dictionaries[ dict[k] ] = {}
				end
				@@reverse_dictionaries[ dict[k] ][ key ] = k
			end
#puts "Notebot: i18n: added dictionary at #{key.to_s}: #{dict.to_s[0..30] + '...'}"
		end

		def remove_dictionary(key)
			@@dictionaries.delete(key)
			@@reverse_dictionary.keys.each do |k|
				@@reverse_dictionaries[ k ].delete(key)
			end
		end

		def lang_of(word, options={})
			langs = []
			
			from = options[:from]
			if not I18n.dictionaries.key?(from)
				from = nil
			end
			
			if options[:word]
				key = @@dictionaries[from][ options[:word] ]
			end
			
			@@dictionaries.keys.each do |d|
				@@dictionaries[d].keys.each do |w|
					if w == word
						match = true
						if not from.nil?
							if not key.nil?
								if not key == @@dictionaries[d][w]
									match == false
								end
							elsif not I18n.t( 
							  I18n.t(w, {:from => d, :to => from}),
							  {:from => from, :to => d})
								match = false
							end
						end
						
						if match
							langs.push(d)
						end
						match = nil
					end
				end
			end
			return (langs.length == 1)? langs[0]: langs
		end

		def t(word, options={})
			options = {:from => @@default_language}.merge options

			if options[:to].nil?
				return nil
			end

			if not @@dictionaries.key?(options[:from])
				return nil
			end

			if options[:to] == options[:from]
				return word
			end

			key = @@dictionaries[ options[:from] ][word]
			if key.nil?
				return nil
			end

			if options[:to].is_a?(Symbol) and
			  ( not @@dictionaries.key?(options[:to]) )
				return nil
			end

			if not options[:to].is_a?(Array)
				return @@reverse_dictionaries[key][ options[:to] ]
			else
				return_arr = []
				options[:to].each do |to|
					return_arr.push @@reverse_dictionaries[ key ][ to ]
				end
				return return_arr
			end
		end
	end
end
