require_relative 'ErrorReport'
require_relative 'HashGenerator'

class HashChecker
	def verify_hash history, hash_container
		an_error = ErrorReport::new
		a_hash = HashGenerator::new

		i = 0
		for transaction in history
			newarr = transaction.split(/[\s|]+/)
			lno = newarr[0]
			this_hash = newarr[newarr.length-1]

			a_test = a_hash.compare this_hash, hash_container[i]
			if (a_test == false)
				an_error.report "Line #{lno}", " String '#{transaction}' hash set to #{this_hash}, should be #{hash_container[i]}"
				return -1
			end
			i = i + 1;
		end
		return 0
	end
end
