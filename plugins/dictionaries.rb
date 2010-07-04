# encoding: utf-8

if not File.directory? "dictionaries"
	puts "Notebot: plugins/dictionaries - no dictionaries directory, creating"
	Dir.mkdir "dictionaries"
end
if not File.directory? "dictionaries_conf"
	puts "Notebot: plugins/dictionaries - no dictionaries directory, creating"
	Dir.mkdir "dictionaries_conf"
end

require "plugins/dictionaries/dictionary_h"
require "plugins/dictionaries/dictionary_user"
require "plugins/dictionaries/dictionary_admin"
require "plugins/dictionaries/dictionary_author"
