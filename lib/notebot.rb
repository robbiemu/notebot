# encoding: utf-8

module Notebot
	class << self
	
		@@traps = []
		@@irc = Cinch.setup :verbose => true do
			server "irc.freenode.org"
			nick "testing_notes"
			channels %w(#notebot)
		end
		
		def irc()
			@@irc
		end
		
		def irc=(arg)
			@@irc=arg
		end
		
		def trap(p)
			@@traps.push(p)
		end
		
		def on_exit()
			@@traps.each do |p|
				p.call
			end
		end
		
		def exit()
			Notebot.on_exit
			Notebot.irc.quit
			exit()
		end
	end
end

["HUP", "INT", "TERM"].each do |term|
	Signal.trap(term) do
		Notebot.irc.quit("Shutting down on SIGNAL")
		Notebot.on_exit
		puts "Notebot: on_exit wrapped up"
		exit()
	end
end
