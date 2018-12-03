class SeedChecker
	attr_accessor :seed_ret

	def initialize
    	@seed_ret = 0;
	end

	def check_seed val
		input = val[0].to_i unless val[0].match(/[^[:digit:]]+/)
		if input.is_a? Integer
			@seed_ret = input
		else
			@seed_ret = 0
		end
	end
end
