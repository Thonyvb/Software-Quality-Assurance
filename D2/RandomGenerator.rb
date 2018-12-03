class RandomGenerator
	def initialize seed
		@seed = seed
		srand seed
	end

	def get_loc min, max
		r = rand(min..max)
	end
end
