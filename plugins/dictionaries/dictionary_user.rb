# encoding: utf-8

module DictionaryUtilities
	class << self

		def buscar(m)
			unless Notebot.banned.member?(m.nick)
				dict = key = ""
				t = m.args[:text]
				if m.args[:dict] =~ /^\?\s*/
					dict = m.args[:dict].sub(/^\?\s*/, "")
					if not t.sub!(/^\s*(\S+)\s*/) { || key = $1; "" }
						format=true
					end
				else
					if not t.sub!(/^\s*(\S+)\s+(\S+)\s*/) { || dict = $1; key = $2; "" }
						format= true			
					end
				end
				if not format
					m.reply "format: !search <dict> <key>"
				elsif not Notebot.dictionaries.member?(dict)
					m.reply "no hay dictionario: #{dict}"
				elsif not Notebot.closed.member?(dict)
					m.reply "el dictionario está cerrado: #{dict}"					
				elsif not Notebot.dictionaries[dict].member?(key)
					m.reply "no hay llave: #{key}"
				else
					m.reply Notebot.dictionaries[ dict ][ key ]
				end
			end
		end

	end
end

Notebot.irc.add_pattern(:searches, /\?\s*(?:#{Notebot.dictionaries.join("|")})|\!(?:search|buscar|[sb]|\?)/ )
Notebot.irc.plugin(":dict-searches :text", :prefix => false) do |m|
	DictionaryUtilities.buscar(m)
end
