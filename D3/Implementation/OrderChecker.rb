require_relative 'ErrorReport'

class OrderChecker
	def verify_order history
		i = 0
		an_error = ErrorReport::new

		for transaction in history
			newarr = transaction.split(/[\s|]+/)
			lno = newarr[0]

			if lno.to_i != i
				an_error.report "Line #{lno}", " Invalid block number #{lno}, should be #{i}"
				return -1
			end
			i = i + 1;
		end
		return 0
	end
end
