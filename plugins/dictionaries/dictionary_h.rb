# encoding: utf-8

module Dictionaries

	@@dictionaries = {}
	@@closed = Conf.marshal("dictionaries_conf/closed") || []

	def dictionaries_init()
	#call init() after requiring this file
		Dir.glob("dictionaries/*").reject{ |e| e =~ /~/}.select{|e| not File.directory? e  }.each do |fh|
			# files not matching gedit and vi temporary files
			dict = (fh.split("/"))[1]
			Notebot.dictionaries[dict] = Conf.marshal(fh)
			puts "Notebot: dictionary loaded: #{dict} (from #{fh})"
		end
	end

	def dictionaries()
		@@dictionaries
	end

	def dictionaries=(arg)
		@@dictionaries=arg
	end

	def closed()
		@@closed
	end

	def closed=(arg)
		@@closed=arg
	end

end

Notebot.extend ( Dictionaries )

Notebot.trap lambda {
	Notebot.dictionaries.each do |d|
		Conf.marshal("dictionaries/#{d[0]}", d[1])
		puts "Notebot: dictionary saved: #{d[0]}: #{d[1]}"
	end
	Conf.marshal("dictionaries_conf/closed", Notebot.closed)
}
