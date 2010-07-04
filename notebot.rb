#!/usr/bin/env ruby
# encoding: utf-8

require 'cinch'
require 'fileutils'

$:.push(".").uniq! # ruby 1.9 load path bug-fix
require 'lib/notebot'
require 'lib/marshal'
	Conf.SAVE_DIR = File.expand_path(".")
	Conf.TMP_DIR = "/tmp"
require 'lib/admin'

require 'plugins/dictionaries'
	Notebot.dictionaries_init()

Notebot.irc.plugin "hello" do |m|
	m.reply "Hello, #{m.nick} - I'm just a bot, not a human!"
end


Notebot.irc.run
