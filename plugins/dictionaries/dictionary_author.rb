# encoding: utf-8

module DictionaryAuthor
	class << self

		def add(m)
			if Notebot.users.member?(m.nick)
				dict = key = ""
				t = m.args[:text]
				if m.args[:dict] =~ /^\+\s*/
					dict = m.args[:dict].sub(/^\+\s*/, "")
					if not t.sub!(/^\s*(\S+)\s+/) { || key = $1; "" }
						format=true
					end
				else
					if not t.sub!(/^\s*(\S+)\s+(\S+)\s+/) { || dict = $1; key = $2; "" }
						format= true			
					end
				end
				if not format
					m.reply "format: !add <dict> <key> <val>[...<vals>]"
				elsif not Notebot.dictionaries.member?(dict)
					m.reply "no hay dictionario: #{dict}"
				elsif not Notebot.closed.member?(dict)
					m.reply "el dictionario está cerrado: #{dict}"					
				elsif Notebot.dictionaries[dict].member?(key)
					m.reply "ya existe la llave. usa en lugar de esa !reponer"
				else
					dictionary = Notebot.dictionaries[ dict ]
					dictionary[ key ] = t
				end
			end
		end
		
		def replace(m)
			if Notebot.users.member?(m.nick)
				dict = key = ""
				t = m.args[:text]
				if m.args[:dict] =~ /^\~\s*/
					dict = m.args[:dict].sub(/^\~\s*/, "")
					if not t.sub!(/^\s*(\S+)\s+/) { || key = $1; "" }
						format=true
					end
				else
					if not t.sub!(/^\s*(\S+)\s+(\S+)\s+/) { || dict = $1; key = $2; "" }
						format= true			
					end
				end
				if not format
					m.reply "format: !replace <dict> <key> <val>[...<vals>]"
				elsif not Notebot.dictionaries.member?(dict)
					m.reply "no hay dictionario: #{dict}"
				elsif not Notebot.closed.member?(dict)
					m.reply "el dictionario está cerrado: #{dict}"					
				elsif not Notebot.dictionaries[dict].member?(key)
					m.reply "no existe la llave: #{key}"
				else
					dictionary = Notebot.dictionaries[ dict ]
					dictionary[ key ] = t
				end
			end
		end

		def prune(m)
			if Notebot.users.member?(m.nick)
				dict = key = ""
				t = m.args[:text]
				if m.args[:dict] =~ /^\-\s*/
					dict = m.args[:dict].sub(/^\-\s*/, "")
					if not t.sub!(/^\s*(\S+)\s*/) { || key = $1; "" }
						format=true
					end
				else
					if not t.sub!(/^\s*(\S+)\s+(\S+)\s*/) { || dict = $1; key = $2; "" }
						format= true			
					end
				end
				if not format
					m.reply "format: !prune <dict> <key>"
				elsif not Notebot.dictionaries.member?(dict)
					m.reply "no hay dictionario: #{dict}"
				elsif not Notebot.closed.member?(dict)
					m.reply "el dictionario está cerrado: #{dict}"					
				elsif not Notebot.dictionaries[dict].member?(key)
					m.reply "no hay llave: #{key}"
				else
					Notebot.dictionaries[ dict ] -= [ key ] 
				end
			end
		end

	end
end

Notebot.irc.add_pattern(:adds, /\+\s*(?:#{Notebot.dictionaries.keys.join("|")})|\!(?:add|añadir|a|\+)/ )
Notebot.irc.plugin(":dict-adds :text", :prefix => false) do |m|
	DictionaryAuthor.add(m)
end

Notebot.irc.add_pattern(:replaces, /\~\s*(?:#{Notebot.dictionaries.keys.join("|")})|\!(?:replace|reponer|r|\~)/ )
Notebot.irc.plugin(":dict-replaces :text", :prefix => false) do |m|
	DictionaryAuthor.replace(m)
end

Notebot.irc.add_pattern(:prunes, /\-\s*(?:#{Notebot.dictionaries.keys.join("|")})|\!(?:prune|podar|p|\-)/ )
Notebot.irc.plugin(":dict-prunes :text", :prefix => false) do |m|
	DictionaryAuthor.prune(m)
end
