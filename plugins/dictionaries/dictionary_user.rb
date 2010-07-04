# encoding: utf-8

module DictionaryUtilities
	class << self

		def buscar(m)
		  unless Notebot.banned.member?(m.nick)
			  as = m.args[:text].split()
			  dict = as[0]
			  key = as[1]
			  if as.length < 2
			  	m.reply "format: !search <dict> <key>"
				elsif not Notebot.dictionaries.member?(dict)
					m.reply "no hay dictionario: #{dict}"
				elsif not Notebot.dictionaries[dict].member?(key)
					m.reply "no hay llave: #{key}"
				else
				  m.reply Notebot.dictionaries[ dict ][ key ]
				end
			end
		end

	end
end

Notebot.irc.add_pattern(:searches, "_search|_buscar|s|b|\?")
Notebot.irc.plugin(":v-searches :text", :prefix => false) do |m|
	DictionaryUtilities.buscar(m)
end
