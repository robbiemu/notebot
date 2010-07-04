# encoding: utf-8

require "plugins/dictionaries/dictionary_h"
require "plugins/dictionaries/dictionary_user"
require "plugins/dictionaries/dictionary_admin"
require "plugins/dictionaries/dictionary_author"

if not File.directory? "dictionaries"
	puts "Notebot: plugins/dictionaries - no dictionaries directory, creating"
	Dir.mkdir "dictionaries"
end
if not File.directory? "dictionaries_conf"
	puts "Notebot: plugins/dictionaries - no dictionaries directory, creating"
	Dir.mkdir "dictionaries_conf"
end
