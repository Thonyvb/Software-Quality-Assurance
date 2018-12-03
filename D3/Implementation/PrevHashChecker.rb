require_relative 'ErrorReport'
require_relative 'HashGenerator'


class PrevHashChecker
	def verify_prev history
		an_error = ErrorReport::new
		a_hash = HashGenerator::new


		i = 0
		transactions = []
		for transaction in history
			transactions[i] = transaction
			newarr = transaction.split(/[\s|]+/)
			lno = newarr[0]
			this_hash = newarr[newarr.length-1]

			##compare if prev hash is correct
			if lno != '0'
				prev_hash = newarr[1]
				newarr = transactions[i-1].split(/[\s|]+/)
				this_hash = newarr[newarr.length-1]
				a_test = a_hash.compare prev_hash, this_hash

				if (a_test == false)
					an_error.report "Line #{lno}", "Previous hash was #{prev_hash}, should be #{this_hash}"
					return -1
				end
			end
			i = i + 1;
		end
		return 0
		
	end
end
