# encoding: utf-8

module Admin
	@@admins = Conf.marshal( "users/admins" ) || []
	@@authors = Conf.marshal( "users/authors" ) || []
	@@users = (@@admins + @@authors).uniq
	@@banned = Conf.marshal( "users/banned" ) || []

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

module AdminUtilities
	class << self

		def _ban(m)
			if Notebot.admins.member?(m.nick)
				Notebot.banned = (Notebot.banned + m.args[:text]).uniq

				Notebot.admins = (Notebot.admins - [ m.args[:text] ]).uniq
				Notebot.authors = (Notebot.authors - [ m.args[:text] ]).uniq
				Notebot.users = (Notebot.users - [ m.args[:text] ]).uniq
			end
		end

		def _author(m)
			if Notebot.admins.member?(m.nick)
				Notebot.authors = (Notebot.authors + [ m.args[:text] ]).uniq
				Notebot.users = (Notebot.users + [ m.args[:text] ]).uniq
			end
		end

		def _admin(m)
			if Notebot.admins.member?(m.nick)
				Notebot.admins = (Notebot.admins + [ m.args[:text] ]).uniq
				Notebot.users = (Notebot.users + [ m.args[:text] ]).uniq
			end
		end
		
		def _users_save(m)
			if Notebot.admins.member?(m.nick)
				m.reply "ho"
				ad = Notebot.admins.to_s.length 
				au = Notebot.authors.to_s.length
				b = Notebot.banned.to_s.length
				if (ad+au+u+b) > 1000000000 # ~200MB
					adc = Notebot.admins.to_s.length 
					auc = Notebot.authors.to_s.length
					bc = Notebot.banned.to_s.length

					m.reply "spam en listas de usarios: ad·#{adc} au·#{auc} u·#{uc} b·#{bc}"
				elsif %x{ du -sh users }.split("\t")[0] =~ /G/
						m.reply "carpeta de gardarse está llena. no puedo completirlo."
				else
					Conf.marshal("users/admins", Notebot.admins)
					Conf.marshal("users/authors", Notebot.authors)
					Conf.marshal("users/banned", Notebot.banned)
				end  
			end
		end

		def _users_load(m)
			if Notebot.admins.member?(m.nick)
				["admins", "authors", "banned"].each do |fh|
					if not File.exists?( "users/#{fh}" )
						m.reply "no existe ninguno archivo para usarios de grupo: #{fh}"
					end
				end
				Notebot.admins = Conf.marshal( "users/admins" )
				Notebot.authors = Conf.marshal( "users/authors" )
				Notebot.users = (admins + authors).uniq
				Notebot.banned = Conf.marshal( "users/banned" )
			end
		end
	end
end

Notebot.irc.add_pattern(:bans, "_ban|_excomulgar")
Notebot.irc.plugin(":v-bans :text", :prefix => false) do |m|
	AdminUtilities._ban(m)
end

Notebot.irc.add_pattern(:authors, "_author|_autor")
Notebot.irc.plugin(":v-authors :text", :prefix => false) do |m|
	AdminUtilities._author(m)
end

Notebot.irc.plugin "_admin :text" do |m|
	AdminUtilities._admin(m)
end

Notebot.irc.add_pattern(:users_saves, "_write_users|_guardar_cuentas")
Notebot.irc.plugin(":v-users_saves :text", :prefix => false) do |m|
	AdminUtilities._users_save(m)
end

Notebot.irc.add_pattern(:users_loads, "_load_users|_cargar_cuentas")
Notebot.irc.plugin(":v-users_loads :text", :prefix => false) do |m|
	AdminUtilities._users_load(m)
end


Notebot.trap lambda {
	Conf.marshal("users/admins", Notebot.admins)
	Conf.marshal("users/authors", Notebot.authors)
	Conf.marshal("users/banned", Notebot.banned)
}
