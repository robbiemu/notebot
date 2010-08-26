#!/usr/bin/env ruby
# encoding: utf-8

#
require 'rubygems'
gem 'cinch', '>= 1.0.1'
require 'cinch'
require 'yaml'
require 'fileutils'

$:.push(".").uniq! # ruby 1.9 load path bug-fix

# libraries ‒ order important
require 'lib/i18n'
require 'lib/marshal'
	Conf.SAVE_DIR = File.expand_path(".")
	Conf.TMP_DIR = "/tmp"
require 'lib/notebot'
	Notebot.init(
		{:server => "irc.freenode.net", :nick => "crawl_ref"},
		{:langs => [:en, :es], :cmd_prefix => "!"}
	)
require 'lib/admin'

# plugins
require 'plugins/dictionaries'
	Notebot.dictionaries_init()


class Default < PluginBase
	include Cinch::Plugin
	
	match "hello"
	
	def execute(m)
		m.reply "Hello, #{m.nick} - I'm just a bot, not a human!"
	end
end
Notebot.register_plugins

Notebot.irc.join(%w{##crawl-ref})
Notebot.irc.start
