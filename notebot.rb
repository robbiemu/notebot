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
	Notebot.init({:langs => [:en, :es], :cmd_prefix => "!"})
require 'lib/admin'

# plugins
require 'plugins/dictionaries'
	Notebot.dictionaries_init()


class Default < PluginBase
	include Cinch::Plugin
	
	match "#{Notebot.const(:default, :cmd_prefix)}hello"
	
	def execute(m)
		m.reply "Hello, #{m.user.nick} - I'm just a bot, not a human!"
	end
end
Notebot.register_plugins()
Notebot.irc.config.verbose = true

Notebot.irc.config.server = "irc.freenode.net"
Notebot.irc.config.nick = "crawl_ref"
Notebot.irc.config.channels = %w(##crawl-ref)

Notebot.irc.start
