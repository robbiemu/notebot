# encoding: utf-8

if not File.directory? "i18n"
	puts "Notebot: lib/admin - no i18n directory! you need at least one default language!"
	exit
end

if not File.directory? "users"
	puts "Notebot: lib/admin - no users directory, creating"
	Dir.mkdir "users"
	FileUtils.touch "users/admins"
	FileUtils.touch "users/authors"
	FileUtils.touch "users/banned"
else
	if not File.exists? "users/admins"
		puts "Notebot: lib/admin - missing users/admins, creating"
		FileUtils.touch "users/admins"
	end
	if not File.exists? "users/authors"
		puts "Notebot: lib/admin - missing users/admins, creating"

		FileUtils.touch "users/authors"
	end
	if not File.exists? "users/banned"
		puts "Notebot: lib/admin - missing users/admins, creating"
		FileUtils.touch "users/banned"
	end
end

Notebot.trap lambda {
	Conf.marshal("users/admins", Notebot.admins)
	Conf.marshal("users/authors", Notebot.authors)
	Conf.marshal("users/banned", Notebot.banned)
}

Notebot.const(:admin, :cmd_prefix, "!_" )

module Admin
	@@admins = Conf.marshal( "users/admins" ) || []
	if @@admins.to_s.length < 47
		puts "Notebot: loaded with admins: #{@@admins}"
	else
		puts "Notebot: loaded with #{@@admins.length} admins"
	end
	@@authors = Conf.marshal( "users/authors" ) || []
	@@users = (@@admins + @@authors).uniq
	@@banned = Conf.marshal( "users/banned" ) || []

	@@one_time_register=true
	@@uuid=%x{ uuidgen }.chomp
	puts "Notebot: generated uuid: #{@@uuid}"

	def uuid?(cand)
		@@uuid == cand
	end

	def one_time_register()
		@@one_time_register
	end

	def one_time_register=(arg)
		@@one_time_register=arg
	end

	def admins()
		@@admins
	end

	def admins=(arg)
		@@admins=arg
	end

	def authors()
		@@authors
	end

	def authors=(arg)
		@@authors=arg
	end

	def users()
		@@users
	end

	def users=(arg)
		@@users=arg
	end

	def banned()
		@@banned
	end

	def banned=(arg)
		@@banned=arg
	end
end
Notebot.extend( Admin )

module AdminUtilies
	class Register < PluginBase
		include Cinch::Plugin
		CMD_PREFIX = :admin
		Regex = Notebot.gen_match("register", {:sym => :admin, :capture_word => true, :post => true})
		match Regex
		
		def execute(m, cmd, uuid)
			lang = I18n.lang_of(cmd, {:from => :en, :word => "register"})
			if Notebot.one_time_register 
				if Notebot.uuid?(uuid)
					Notebot.admins.push(m.user.nick).uniq!
					Conf.marshal("users/admins", Notebot.admins)
						m.reply "#{Notebot.admins}"
					Notebot.one_time_register=false
				else
					_and  = I18n.t("and", {:to => lang})
					_dont_match = I18n.t("no coinciden", {:to => lang, :from => :es})
					m.reply "uuid #{_and} #{uuid} #{_dont_match}" 
				end
			end
		end
	end

	class Ban < PluginBase
		include Cinch::Plugin
		CMD_PREFIX = :admin
		Regex = Notebot.gen_match("ban", {:sym => :admin, :capture_word => true, :post => true})
		match Regex
		
		def execute(m, cmd, target)
			if Notebot.admins.member?(m.user.nick)
				type =  "+"
				lang = I18n.lang_of( cmd, {:from => :en, :word => "ban"})
				type_desc = I18n.t("add", {:to => lang})
				if target.match(/^([+-])/)
					type = $1
					target = target[1..-1]
				end

				if type == "+"
					Notebot.banned = (Notebot.banned + [ target ]).uniq
					Notebot.admins = (Notebot.admins - [ target ]).uniq
					Notebot.authors = (Notebot.authors - [ target ]).uniq
					Notebot.users = (Notebot.users - [ target ]).uniq
				else
					Notebot.banned -= [ target ]
					type_desc = I18n.t("delete", {:to => lang})
				end
				_realizado = I18n.t("realizado", {:to => lang})
				m.reply "#{_realizado} ‒ #{cmd} (#{type_desc}) #{target}"
			end
		end
	end

	class Author < PluginBase
		include Cinch::Plugin
		CMD_PREFIX = :admin
		Regex = Notebot.gen_match("author", {:sym => :admin, :capture_word => true, :post => true})
		match Regex
		
		def execute(m, cmd, target)
			if Notebot.admins.member?(m.user.nick)
				type =  "+"
				lang = I18n.lang_of( cmd, {:from => :en, :word => "author"})
				type_desc = I18n.t("add", {:to => lang})
				if target.match(/^([+-])/)
					type = $1
					target = target[1..-1]
				end

				if type == "+"
					Notebot.authors = (Notebot.authors + [ target ]).uniq
					Notebot.users = (Notebot.users + [ target ]).uniq
				else
					Notebot.authors -= [ target ]
					type_desc = I18n.t("delete", {:to => lang})
				end
				_realizado = I18n.t("realizado", {:to => lang})
				m.reply "#{_realizado} ‒ #{cmd} (#{type_desc}) #{target}"
			end
		end
	end

	class Admin < PluginBase
		include Cinch::Plugin
		CMD_PREFIX = :admin
		Regex = Notebot.gen_match("admin", {:sym => :admin, :capture_word => true, :post => true})
		match Regex
		
		def execute(m, cmd, target)
			if Notebot.admins.member?(m.user.nick)
				type =  "+"
				lang = I18n.lang_of( cmd, {:from => :en, :word => "admin"})
				type_desc = I18n.t("add", {:to => lang})
				if target.match(/^([+-])/)
					type = $1
					target = target[1..-1]
				end

				if type == "+"
					Notebot.admins = (Notebot.admins + [ target ]).uniq
					Notebot.users = (Notebot.users + [ target ]).uniq
				else
					Notebot.admins -= [ target ]
					type_desc = I18n.t("delete", {:to => lang})
				end
				_realizado = I18n.t("realizado", {:to => lang})
				m.reply "#{_realizado} ‒ #{cmd} (#{type_desc}) #{target}"
			end
		end
	end
	
	class Permissions < PluginBase
		include Cinch::Plugin
		CMD_PREFIX = :admin
		Regex = Notebot.gen_match("perms", {:sym => :admin, :post => true})
		match Regex

		def execute(m, target)
			if Notebot.admins.member?(m.user.nick)
				reply = []
				if Notebot.admins.member?( target )
					reply.push "admin"
				end
				if Notebot.users.member?( target )
					reply.push "author"
				end
				if Notebot.banned.member?( target )
					reply.push "banned"
				end
				m.reply( "perms: #{target} " + reply.to_s)
			end
		end
	end
	
	class WriteUsers < PluginBase
		include Cinch::Plugin
		CMD_PREFIX = :admin
		Regex = Notebot.gen_match("write users", {:sym => :admin, :capture_word => true})
		match Regex
		
		def execute(m, cmd)
			if Notebot.admins.member?(m.user.nick)
				lang = I18n.lang_of( cmd, {:from => :en, :word => "write users"})
				ad = Notebot.admins.to_s.length 
				au = Notebot.authors.to_s.length
				b = Notebot.banned.to_s.length
				if (ad+au+u+b) > 1000000000 # ~200MB
					adc = Notebot.admins.to_s.length 
					auc = Notebot.authors.to_s.length
					bc = Notebot.banned.to_s.length

					_spam = I18n.t("spam en listas de usarios", {:from => :es, :to => lang})
					m.reply "#{_spam}: ad·#{adc} au·#{auc} u·#{uc} b·#{bc}"
				elsif %x{ du -sh users }.split("\t")[0] =~ /G/
					m.reply I18n.t("carpeta de gardarse está llena. no puedo completirlo.", {:from => :es, :to => :en})
				else
					Conf.marshal("users/admins", Notebot.admins)
					Conf.marshal("users/authors", Notebot.authors)
					Conf.marshal("users/banned", Notebot.banned)

					_saved = I18n.t("estan escritos en el disco", {:from => :es, :to => lang})
					m.reply "#{_saved}: ad·#{adc} au·#{auc} u·#{uc} b·#{bc}"
				end
				
				_realizado = I18n.t("realizado", {:to => lang})
				m.reply "#{_realizado} ‒ #{cmd} (#{type_desc}) #{target}"
			end
		end
	end

	class LoadUsers < PluginBase
		include Cinch::Plugin
		CMD_PREFIX = :admin
		Regex = Notebot.gen_match("load users", {:sym => :admin, :capture_word => true})
		match Regex
		
		def execute(m, cmd)
			lang = I18n.lang_of( cmd, {:from => :en, :word => "load users"})
			if Notebot.admins.member?(m.user.nick)
				["admins", "authors", "banned"].each do |fh|
					if not File.exists?( "users/#{fh}" )
						_no_user = I18n.t("no existe ninguno archivo para usarios de grupo", {:from => :es, :to => lang})
						m.reply "#{_no_user}: #{fh}"
					end
				end
				Notebot.admins = Conf.marshal( "users/admins" )
				Notebot.authors = Conf.marshal( "users/authors" )
				Notebot.users = (admins + authors).uniq
				Notebot.banned = Conf.marshal( "users/banned" )
			end
			_se_cargan = I18n.t("se cargan", {:from => :es, :to => lang})
			m.reply "#{_se_cargan}: ad·#{adc} au·#{auc} u·#{uc} b·#{bc}"
		end
	end
end
