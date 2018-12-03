class ArgsChecker
	def check_args val
		raise "Enter a seed and only a seed" unless val.count == 1
	end
end
