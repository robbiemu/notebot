# encoding: utf-8

module Dictionaries

	@@dictionaries = Dir|| []
	@@closed = Conf.marshal("dictionaries_conf/closed") || []

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
	Dir.glob("dictionaries/*").reject { |e| e =~ /^.|(?:~|.swp)$/ }.reject { |e| File.directory? e}.each do |fh|
	# files not matching gedit and vi temporary files
		Conf.marshal("dictionaries/#{fh}", Notebot.dictionaries[fh])
	end
	Conf.marshal("dictionaries_conf/closed", Notebot.closed)
}
