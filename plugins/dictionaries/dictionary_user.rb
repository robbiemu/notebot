# encoding: utf-8

module DictionaryUtilities
	class Search < PluginBase
		include Cinch::Plugin

		cmds = I18n.t( "search", {:to => Notebot.const(:default, :langs)} ).join("|")
		pre = Notebot.const(:default, :cmd_prefix)
		match_str = '(\?)\s*(.*)\s*(.*)|'+"#{pre}(#{cmds})"+'\s+(.*)\s*(.*)'
		Regex = /#{match_str}/
		match Regex

		def execute(m, cmd, query)
			unless Notebot.banned.member?(m.user.nick)
				if cmd == "?"
					lang = Notebot.const(:default, :language)
				else
					lang = I18n.lang_of(cmd, {:from => :en, :word => "search"})
				end

				dict, key = query.split(/\s+/, 2)

				if not dict or not key
					_key = I18n.t("key", {:to => lang})
					_format = I18n.t("format", {:to => lang})
					_cmd = I18n.t("search", {:to => lang})
					m.reply "#{_format}: !#{_cmd} <dict> <#{_key}>"
				elsif not Notebot.dictionaries.key?(dict)
					_no_dict = I18n.t("no hay diccionario", {:from => :es, :to => lang})
					m.reply "#{_no_dict}: #{dict}"
				elsif Notebot.closed.member?(dict)
					_closed = I18n.t("el diccionario está cerrado", {:from => :es, :to => lang})				
					m.reply "#{_closed}: #{dict}"					
				elsif not Notebot.dictionaries[dict].key?(key)
					_no_key = I18n.t("no hay llave", {:from => :es, :to => lang})
					m.reply "#{_no_key}: #{key}"
				else
					m.reply Notebot.dictionaries[ dict ][ key ]
				end
			end
		end

	end
end
