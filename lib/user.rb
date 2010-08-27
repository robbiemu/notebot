module UserUtilies
	class Help < PluginBase
		include Cinch::Plugin

		Regex = Notebot.gen_match("help", {:capture_word => true, :post => true})
		match Regex

		def execute(m, cmd, query)
			lang = I18n.lang_of(cmd, {:from => :en, :word => "help"})

			w, q = query.split("\s")
			w_en = I18n.t(w, {:from => lang, :to => :en})
			return two_args(w_en,q, lang,m) if not q.nil?

			if w_en == "list" 
				list_commands(m, lang)
			end

			query_as_classname = I18n.t(w, {:from => lang, :to => :en}).capitalize

			Notebot.plugins.each do |c|
				if c.to_s == query_as_classname 
					m.reply c::Help[lang], true
					break
				end
			end
		end
		
		def two_args(w_en,q, lang, m)
			if w_en == "list"
				case q
				when I18n.t("commands", {:from => :en, :to => lang})
					list_commands(m, lang)
				when I18n.t( "plugins", {:from => :en, :to => lang})
					m.reply Notebot.plugins.map { |c| (c == Default)? nil: c.to_s }.delete_if {|c| c.nil?}.sort.join(", "), true
				when I18n.t( "dictionaries", {:from => :en, :to => lang})
					m.reply "#{q.capitalize}:" + Notebot.dictionaries.map { |d| d[0]}.sort.join(", "), true
				end
			elsif w_en == "regex"
				query_as_classname = I18n.t(q, {:from => lang, :to => :en}).capitalize
				if query_as_classname == "Perms"
					query_as_classname = "Permissions"
				end
				Notebot.plugins.each do |c|
					reply = true
					if (not Notebot.admins.member?(m.user.nick)) and (c.to_s =~ /Admin/)
						reply = false
					end

					if c == Default
						reply = false
					end
					
					if reply
						classname = (c.to_s.split("::"))[1]
						if classname == query_as_classname
							regex = (c::Regex.is_a?(Regexp))? c::Regex.source: c::Regex
							m.reply "Regex (#{q}): /#{regex}/", true
							break
						end
					end
				end
			end
		end
		
		def list_commands(m, lang)
			m.reply I18n.t("commands", {:from => :en, :to => lang}).capitalize + ": " + Notebot.plugins.map { |c| 
				if (c.to_s =~ /Admin/) and not Notebot.admins.member?(m.user.nick)
					nil
				else
					case c.to_s 
					when "Default"
						nil
					when "AdminUtilies::Permissions"
						Notebot.const(:admin, :cmd_prefix) + "perms"
					when "AdminUtilies::WriteUsers"
						Notebot.const(:admin, :cmd_prefix) + I18n.t( "write users", {:to => lang} )
					when "AdminUtilies::LoadUsers"					
						Notebot.const(:admin, :cmd_prefix) + I18n.t( "load users", {:to => lang} )
					else
						prefix = Notebot.const(:default, :cmd_prefix)
						if c.const_defined?("CMD_PREFIX")
							prefix = Notebot.const(c::CMD_PREFIX, :cmd_prefix)
						end
						prefix + I18n.t( (c.to_s.downcase.split("::"))[-1], {:to => lang} )
					end
				end
			}.delete_if {|c| c.nil? }.sort.join(", "), true
		end
	end
end
