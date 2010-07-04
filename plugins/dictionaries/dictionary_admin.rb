# encoding: utf-8

module DictionaryAdmin
	class << self

		def _save(m)
			if Notebot.admins.member?(m.nick)
				dict = m.args[:text]
				if not dict
					m.reply "format: !_save <dict>"
				else
					if not Notebot.dictionaries.member?( dict )
						m.reply "no hay dicitonario: #{dict}"
					elsif Notebot.dictionaries[ dict ].to_s.length > 1000000000 # ~200MB
						m.reply "dictionario #{dict} es demasiado tamañado para gardarse"
					elsif %x{ du -sh dictionaries }.split("\t")[0] =~ /G/
						m.reply "carpeta de gardarse está llena. no puedo completirlo."
					else
						Conf.marshal("dictionaries/#{dict}", Notebot.dictionaries[ dict ])
					end
				end  
			end
		end

		def _load(m)
			if Notebot.admins.member?(m.nick)
				dict = m.args[:text]
				if not dict
					m.reply "format: !_load <dict>"
				else
					if not File.exists?( "dictionaries/#{dict}" )
						m.reply "no hay dicitonario: #{dict}"
					elsif Notebot.dictionaries.member?( dict )
						m.reply "ya hay un dictionario llamado '#{dict}'. usa !_recargar"
					else
						Notebot.dictionaries[ dict ] = Conf.marshal( "dictionaries/#{dict}" )
					end
				end  
			end
		end

		def _reload(m)
			if Notebot.admins.member?(m.nick)
				dict = m.args[:text]
				if not dict
					m.reply "format: !_reload <dict>"
				else
					if not File.exists?( "dictionaries/#{dict}" )
						m.reply "no hay dicitonario: #{dict}"
					else
						Notebot.dictionaries[ dict ] = Conf.marshal( "dictionaries/#{dict}" )
					end
				end  
			end
		end

		def _open(m)
			if Notebot.admins.member?(m.nick)
					dict = m.args[:text]
				if not dict
					m.reply "format: !_open <dict>"
				else
					Notebot.closed -= [dict]
				end
			end
		end

		def _close(m)
			if Notebot.admins.member?(m.nick)
					dict = m.args[:text]
				if not dict
					m.reply "format: !_close <dict>"
				else
					Notebot.closed.push(dict).uniq!
				end
			end
		end
		
		def _start(m)
			if Notebot.admins.member?(m.nick)
					dict = m.args[:text]
				if not dict
					m.reply "format: !_new <dict>"
				elsif Notebot.dictionaries.member?( dict )
					m.reply "ya hay un dictionario llamado '#{dict}'"		
				else
					Notebot.dictionaries[ dict ] = []
				end
			end
		end

	end
end

Notebot.irc.add_pattern(:saves, /\!(?:_save|_guadar)\b/ )
Notebot.irc.plugin(":v-saves :text", :prefix => false) do |m|
	DictionaryAdmin._save(m)
end

Notebot.irc.add_pattern(:loads, /\!(?:_load|_cargar)\b/ )
Notebot.irc.plugin(":v-loads :text", :prefix => false) do |m|
	DictionaryAdmin._load(m)
end

Notebot.irc.add_pattern(:reloads, /\!(?:_reload|_recargar)\b/ )
Notebot.irc.plugin(":v-reloads :text", :prefix => false) do |m|
	DictionaryAdmin._reload(m)
end

Notebot.irc.add_pattern(:opens, /\!(?:_open|_abrir)\b/ )
Notebot.irc.plugin(":v-opens :text", :prefix => false) do |m|
	DictionaryAdmin._open(m)
end

Notebot.irc.add_pattern(:closes, /\!(?:_close|_cerrar)\b/ )
Notebot.irc.plugin(":v-closes :text", :prefix => false) do |m|
	DictionaryAdmin._save(m)
end

Notebot.irc.add_pattern(:starts, /\!(?:_new|_nuevo)\b/ )
Notebot.irc.plugin(":v-starts :text", :prefix => false) do |m|
	DictionaryAdmin._start(m)
end
