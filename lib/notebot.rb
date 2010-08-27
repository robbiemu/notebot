# encoding: utf-8

module Notebot
	class << self
	
		@@constants = {:default => {}}
		@@plugins = []
		@@traps = []
		@@irc = Cinch::Bot.new
		
		def init(options)
			@@initial_options = {
				:langs => :en, 
				:default_language => :en,
				:cmd_prefix => "!"
			}.merge options
			
			@@irc = Cinch::Bot.new do
				configure do |c|
					c.plugins.prefix = ""
					c.verbose = false
				end
			end
			
			@@constants[:default][:langs] = @@initial_options[:langs]
			@@initial_options[:langs].each do |lang|
				I18n.add_dictionary( lang, YAML.load_file("i18n/#{lang}") || {})
			end
			@@constants[:default][:cmd_prefix] = @@initial_options[:cmd_prefix]
			@@constants[:default][:language] = @@initial_options[:default_language]
			I18n.default_language = @@initial_options[:default_language]
		end
		
		def irc()
			@@irc
		end
		
		def irc=(arg)
			@@irc=arg
		end

		def const(dict, key, val=nil)
			if val.nil?
				if not @@constants.key?(dict)
					return nil
				else
					return @@constants[dict][key]
				end
			else
				if not @@constants.key?(dict)
					@@constants[dict] = {}
				end

				@@constants[dict][key] = val

				if dict == :default and key == :language
					I18n.default_language = val
				end
			end
		end

		def raw_gen_match(string, options)
			options = {
				:sym => :default,
				:langs => Notebot.const(:default, :langs), 
				:capture_word => false, 
				:post => false}.merge options
			return unless options[:sym]

			keys = I18n.t(string, {:to => options[:langs]})
			if keys.nil?
				puts "Notebot: i18n: missing keys for string:#{string} in languages:" + options[:langs].to_s
				Kernel.exit
			end
			keys = keys.join("|")
			
			cmd = Notebot.const(options[:sym], :cmd_prefix)
			cmd += options[:capture_word]? "(": "(?:"
			cmd += keys
			cmd += ")"
			
			return cmd + '\s+' + ((options[:post])? "(.*)": "")
		end

		def gen_match(*args)
			regex = Notebot.raw_gen_match(*args)
			return /#{regex}/
		end

		def plugins()
			@@plugins
		end

		def plugin_to_register(p)
			@@plugins.push(p)
		end
		
		def register_plugins()
			@@plugins.each do |p|
				Notebot.irc.register_plugin(p)
			end
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
			Kernel.exit()
		end
	end
end

class PluginBase
	def self.inherited(subclass)
		Notebot.plugin_to_register(subclass)
	end
end

["HUP", "INT", "TERM"].each do |term|
	Signal.trap(term) do
		Notebot.irc.quit("Shutting down on SIG" + term)
		puts "\n"
		Notebot.on_exit
		puts "Notebot: on_exit wrapped up"
		exit()
	end
end
