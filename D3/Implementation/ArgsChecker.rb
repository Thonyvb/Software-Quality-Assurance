require 'pathname'

class ArgsChecker
	def check_args val
		if  val.count != 1
			puts "Usage: ruby verifier.rb <file>"
			# exit
			return -1
		else
			return 0
		end
	end

	def check_file_existance pn
		if !pn.exist? 
			puts "file does not exist"
			return -1
		else
			return 0
		end
	end
end
