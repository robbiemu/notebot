# encoding: utf-8

module DictionaryAuthor
	class Add < PluginBase
		include Cinch::Plugin
		
		cmds = I18n.t("add", {:to => Notebot.const(:default, :langs)}).join("|")
		# beware that using I18n directly will not gracefully error out if the word is missing in the dictionaries
		pre = Notebot.const(:default, :cmd_prefix)
		Regex = '(\+)\s*(.*)|'+"#{pre}(#{cmds})"+'\s+(.*)'
		match Regex

		def execute(m, cmd, query)
			if Notebot.users.member?(m.user.nick)
				if cmd == "+"
					lang = Notebot.const(:default, :language)
				else
					lang = I18n.lang_of(cmd, {:from => :en, :word => "add"})
				end
		
				dict, query = query.split(/\s+/, 2)
				
				if query =~ /^"(.*?)"/
					key = $1
					query.sub!(/^".*?"\s+/, "")
				else
					query.sub!(/^(\S+)\s+/, "")
					key = $1
				end

				if (query =~ /^\s*$/) or (dict =~ /^\s*$/) or (key =~ /^\s*$/)
					format = true
				end

				if format
					_key = I18n.t("key", {:to => lang})
					_format = I18n.t("format", {:to => lang})
					_cmd = I18n.t("add", {:to => lang})
					m.reply "#{_format}: !#{_cmd} <dict> \"<#{_key}>\" <val>"
				elsif not Notebot.dictionaries.key?(dict)
					_no_dict = I18n.t("no hay diccionario", {:from => :es, :to => lang})
					m.reply "#{_no_dict}: #{dict}"
				elsif Notebot.closed.member?(dict)
					_closed = I18n.t("el diccionario está cerrado", {:from => :es, :to => lang})				
					m.reply "#{_closed}: #{dict}"					
				elsif Notebot.dictionaries[dict].member?(key)
					pre = Notebot.const(:default, :cmd_prefix)
					_reponer = I18n.t("reponer", {:from => :es, :to => lang})		
					_msg = I18n.t("ya existe la llave. usa en lugar de esa", {:from => :es, :to => lang})
					m.reply "#{_msg} #{pre}#{_reponer}"
				else
					Notebot.dictionaries[ dict ][ key ] = query
					m.reply "#{dict} #{key} #{Notebot.dictionaries[ dict ][ key ]}"
				end
			end
		end
	end

	class Replace < PluginBase
		include Cinch::Plugin
		
		cmds = I18n.t("replace", {:to => Notebot.const(:default, :langs)}).join("|")
		pre = Notebot.const(:default, :cmd_prefix)
		Regex = '(\/\/)\s*(.*)\s*(.*)|'+"#{pre}(#{cmds})"+'\s+(.*)\s*(.*)'
		match Regex

		def execute(m, cmd, dict, query)		
			if Notebot.users.member?(m.user.nick)
				if cmd == "//"
					lang = Notebot.const(:default, :language)
				else
					lang = I18n.lang_of(cmd, {:from => :en, :word => "replace"})
				end
				
				if dict =~ /^\s*$/
					format = true
				elsif query =~ /^\s*$/
					format = true
				end

				if query =~ /^"(.*?)"/
					key = $1
					query.sub!(/^".*?"\s+/, "")
					val = query
				else
					query.sub!(/^(\S+)\s+/, "")
					key = $1
				end

				if not format
					_key = I18n.t("key", {:to => lang})
					_format = I18n.t("format", {:to => lang})
					_cmd = I18n.t("replace", {:to => lang})
					m.reply "#{_format}: !#{_cmd} <dict> \"<#{_key}>\" <val>"
				elsif not Notebot.dictionaries.key?(dict)
					_no_dict = I18n.t("no hay diccionario", {:from => :es, :to => lang})
					m.reply "#{_no_dict}: #{dict}"
				elsif not Notebot.closed.member?(dict)
					_closed = I18n.t("el diccionario está cerrado", {:from => :es, :to => lang})				
					m.reply "#{_closed}: #{dict}"	
				elsif not Notebot.dictionaries[dict].member?(key)
					_no_key = I18n.t("no existe la llave", {:from => :es, :to => lang})				
					m.reply "#{_no_key}: #{key}"
				else
					Notebot.dictionaries[ dict ][ key ] = query
				end
			end
		end
	end

	class Prune < PluginBase
		include Cinch::Plugin
		
		cmds = I18n.t("prune", {:to => Notebot.const(:default, :langs)}).join("|")
		pre = Notebot.const(:default, :cmd_prefix)
		Regex = '(\-)\s*(.*)\s*(.*)|'+"#{pre}(#{cmds})"+'\s+(.*)\s*(.*)'
		match Regex

		def execute(m, cmd, dict, key)		
			if Notebot.users.member?(m.user.nick)
				if cmd == "-"
					lang = Notebot.const(:default, :language)
				else
					lang = I18n.lang_of(cmd, {:from => :en, :word => "prune"})
				end
				
				if not format
					_key = I18n.t("key", {:to => lang})
					_format = I18n.t("format", {:to => lang})
					_cmd = I18n.t("replace", {:to => lang})
					m.reply "#{_format}: !#{_cmd} <dict> \"<#{_key}>\" <val>"
				elsif not Notebot.dictionaries.key?(dict)
					_no_dict = I18n.t("no hay diccionario", {:from => :es, :to => lang})
					m.reply "#{_no_dict}: #{dict}"
				elsif not Notebot.closed.member?(dict)
					_closed = I18n.t("el diccionario está cerrado", {:from => :es, :to => lang})				
					m.reply "#{_closed}: #{dict}"
				elsif not Notebot.dictionaries[dict].member?(key)
					m.reply "no hay llave: #{key}"
				else
					Notebot.dictionaries[ dict ] -= [ key ] 
				end
			end
		end

	end
end
