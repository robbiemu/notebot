# encoding: utf-8

module DictionaryAdmin
	class Save < PluginBase
		include Cinch::Plugin
		
		match Notebot.gen_match("save", {:sym => :admin, :capture_word => true, :post => true})
		
		def execute(m, cmd, dict)
			if Notebot.admins.member?(m.user.nick)
				lang = I18n.lang_of( cmd, {:from => :en, :word => "save"})

				if dict == ""
					pre = Notebot.const(:admin, :cmd_prefix)
					_format = I18n.t("format", {:to => lang})
					m.reply "#{_format}: #{pre}#{cmd} <dict>"
				else
					if not Notebot.dictionaries.key?(dict)
						_no_dict = I18n.t("no hay diccionario", {:from => :es, :to => lang})
						m.reply "#{_no_dict}: #{dict}"
					elsif Notebot.dictionaries[ dict ].to_s.length > 1000000000 # ~200MB
						_dict = I18n.t("dictionary", {:to => lang})
						_is_too_big = I18n("es demasiado grande para gardarse", {:to => lang, :from => :es})
						m.reply "#{_dict} #{dict} #{_is_too_big}"
					elsif %x{ du -sh dictionaries }.split("\t")[0] =~ /G/
						m.reply I18n.t("carpeta de gardarse está llena. no puedo completirlo.", {:to => lang, :from => :es})
					else
						Conf.marshal("dictionaries/#{dict}", Notebot.dictionaries[ dict ])
						_realizado = I18n.t("realizado", {:to => lang})
						m.reply "#{realizado} ‒ #{cmd} #{dict}"
					end
				end  
			end
		end
	end

	class Load < PluginBase
		include Cinch::Plugin
		
		match Notebot.gen_match("load", {:sym => :admin, :capture_word => true, :post => true})
		
		def execute(m, cmd, dict)
			if Notebot.admins.member?(m.user.nick)
				lang = I18n.lang_of( cmd, {:from => :en, :word => "save"})

				if dict == ""
					pre = Notebot.const(:admin, :cmd_prefix)
					_format = I18n.t("format", {:to => lang})
					m.reply "#{_format}: #{pre}#{cmd} <dict>"
				else
					if not File.exists?( "dictionaries/#{dict}" )
						_no_dict = I18n.t("no hay diccionario", {:from => :es, :to => lang})
						m.reply "#{_no_dict}: #{dict}"
					elsif Notebot.dictionaries.member?( dict )
						_already = I18n("ya hay un diccionario llamado", {:from => :es, :to => lang})
						_use = I18n.t("use", {:to => lang})
						pre = Notebot.const(:admin, :cmd_prefix)
						_recargar = I18n.t("reload", {:to => lang})
						m.reply "#{_already} '#{dict}'. #{_use} #{pre}#{_recargar}"
					else
						Notebot.dictionaries[ dict ] = Conf.marshal( "dictionaries/#{dict}" )
						_realizado = I18n.t("realizado", {:to => lang})
						m.reply "#{realizado} ‒ #{cmd} #{dict}"
					end
				end  
			end
		end
	end

	class Reload < PluginBase
		include Cinch::Plugin
		
		match Notebot.gen_match("reload", {:sym => :admin, :capture_word => true, :post => true})
		
		def execute(m, cmd, dict)
			if Notebot.admins.member?(m.user.nick)
				lang = I18n.lang_of( cmd, {:from => :en, :word => "reload"})

				if dict == ""
					pre = Notebot.const(:admin, :cmd_prefix)
					_format = I18n.t("format", {:to => lang})
					m.reply "#{_format}: #{pre}#{cmd} <dict>"
				else
					if not File.exists?( "dictionaries/#{dict}" )
						_no_dict = I18n.t("no hay diccionario", {:from => :es, :to => lang})
						m.reply "#{_no_dict}: #{dict}"
					else
						Notebot.dictionaries[ dict ] = Conf.marshal( "dictionaries/#{dict}" )
						_realizado = I18n.t("realizado", {:to => lang})
						m.reply "#{realizado} ‒ #{cmd} #{dict}"
					end
				end  
			end
		end
	end

	class Open < PluginBase
		include Cinch::Plugin
		
		match Notebot.gen_match("open", {:sym => :admin, :capture_word => true, :post => true})
		
		def execute(m, cmd, dict)
			if Notebot.admins.member?(m.user.nick)
				lang = I18n.lang_of( cmd, {:from => :en, :word => "open"})

				if dict == ""
					pre = Notebot.const(:admin, :cmd_prefix)
					_format = I18n.t("format", {:to => lang})
					m.reply "#{_format}: #{pre}#{cmd} <dict>"
				else
					Notebot.closed -= [dict]
				end
			end
		end
	end
	
	class Close < PluginBase
		include Cinch::Plugin
		
		match Notebot.gen_match("close", {:sym => :admin, :capture_word => true, :post => true})
		
		def execute(m, cmd, dict)
			if Notebot.admins.member?(m.user.nick)
				lang = I18n.lang_of( cmd, {:from => :en, :word => "close"})

				if dict == ""
					pre = Notebot.const(:admin, :cmd_prefix)
					_format = I18n.t("format", {:to => lang})
					m.reply "#{_format}: #{pre}#{cmd} <dict>"
				else
					Notebot.closed.push(dict).uniq!
				end
			end
		end
	end
		
	class Start < PluginBase
		include Cinch::Plugin
		
		match Notebot.gen_match("start", {:sym => :admin, :capture_word => true, :post => true})
		
		def execute(m, cmd, dict)
			if Notebot.admins.member?(m.user.nick)
				lang = I18n.lang_of( cmd, {:from => :en, :word => "start"})

				if dict == ""
					pre = Notebot.const(:admin, :cmd_prefix)
					_format = I18n.t("format", {:to => lang})
					m.reply "#{_format}: #{pre}#{cmd} <dict>"
				elsif Notebot.dictionaries.member?( dict )
					_already = I18n("ya hay un diccionario llamado", {:from => es, :to => lang})
					m.reply "#{already} '#{dict}'"		
				else
					Notebot.dictionaries[ dict ] = []
				end
			end
		end

	end
end
