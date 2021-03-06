# encoding: utf-8

module Conf
	class << self

		@@SAVE_DIR
		@@TMP_DIR
		
		def SAVE_DIR()
			@@SAVE_DIR
		end

		def SAVE_DIR=(arg)
			@@SAVE_DIR=arg
		end

		def TMP_DIR()
			@@TMP_DIR
		end

		def TMP_DIR=(arg)
			@@TMP_DIR=arg
		end

		def marshal(filename,data=nil)
			Dir.chdir(@@SAVE_DIR) do
				if data != nil
					open(filename, "w") { |f| Marshal.dump(data, f) }
				elsif File.exists?(filename)
					begin
						open(filename) { |f| Marshal.load(f) }
					rescue
						return nil
					end
				end
			end
		end
			
		def marshal_destroy(filename)
			Dir.chdir(@@SAVE_DIR) do
				if File.exists?(filename)
					File.delete(filename)
				else
					return "File does not exist."
				end
			end
		end
			
		def marshal_clone(data)
			filename = srand.to_s << '.tmp'
			h = ""
			Dir.chdir(@@TMP_DIR) do
				marshal(filename,data)
				h = marshal(filename)
				marshal_destroy(filename)
			end
			return h
		end

	end #class << self
end
