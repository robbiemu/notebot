# encoding: utf-8

module DictionaryAuthor
	class << self

		def add(m)
			if Notebot.users.member?(m.nick)
				dict = ""
				key = ""
				t = m.args[:text]
				if not t.sub!(/^\s*(\S+)\s+(\S+)\s+/) { || dict = $1; key =$2; "" }
					m.reply "format: !add <dict> <key> <val>[...<vals>]"
				elsif not Notebot.dictionaries.member?(dict)
					m.reply "no hay dictionario: #{dict}"
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
				dict = ""
				key = ""
				t = m.args[:text]
				if not t.sub!(/^\s*(\S+)\s+(\S+)\s+/) { || dict = $1; key =$2; "" }
					m.reply "format: !replace <dict> <key> <val>[...<vals>]"
				elsif not Notebot.dictionaries.member?(dict)
					m.reply "no hay dictionario: #{dict}"
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
				dict = ""
				key = ""
				t = m.args[:text]
				if not t.sub!(/^\s*(\S+)\s+(\S+)\s*/) { || dict = $1; key =$2; "" }
					m.reply "format: !prune <dict> <key>"
				elsif not Notebot.dictionaries.member?(dict)
					m.reply "no hay dictionario: #{dict}"
				elsif not Notebot.dictionaries[dict].member?(key)
					m.reply "no hay llave: #{key}"
				else
					Notebot.dictionaries[ dict ] -= [ key ] 
				end
			end
		end

	end
end

Notebot.irc.add_pattern(:adds, "_add|_añadir|a|\+")
Notebot.irc.plugin(":v-adds :text", :prefix => false) do |m|
	DictionaryAuthor.add(m)
end

Notebot.irc.add_pattern(:replaces, "_replace|_reponer|r|\/")
Notebot.irc.plugin(":v-replaces :text", :prefix => false) do |m|
	DictionaryAuthor.replace(m)
end

Notebot.irc.add_pattern(:prunes, "_prune|_podar|p|\-")
Notebot.irc.plugin(":v-prunes :text", :prefix => false) do |m|
	DictionaryAuthor.prune(m)
end
