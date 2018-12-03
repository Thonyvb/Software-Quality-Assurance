require_relative 'ErrorReport'

class TimeChecker
	def check_time history
		i = 0
		transactions = []
		an_error = ErrorReport::new

		for transaction in history
			newarr = transaction.split(/[\s|]+/)
			lno = newarr[0]
			transactions[i] = transaction
			this_time = newarr[3]
			this_time_arr = this_time.split(/[\s.]+/)
			seconds = this_time_arr[0]
			nanoseconds = this_time_arr[1]

			if i > 0
				prev_tr = transactions[i-1]
				prev_tr_arr = prev_tr.split(/[\s|]+/)
				prev_time = prev_tr_arr[3]

				prev_time_arr = prev_time.split(/[\s.]+/)
				prev_seconds = prev_time_arr[0]
				prev_nanoseconds = prev_time_arr[1]

				## check
				if prev_time.to_f >= this_time.to_f
					if prev_time.to_i > this_time.to_i
						an_error.report "Line #{lno}", " Previous timestamp #{prev_time} >= new timestamp #{this_time}"
						return -1
					end

					if prev_seconds.to_i == seconds.to_i and prev_nanoseconds.to_i >= nanoseconds.to_i
						an_error.report "Line #{lno}", " Previous timestamp #{prev_time} >= new timestamp #{this_time}"
						return -1
					end
				end
			end
			i = i + 1;
		end
		return 0
	end
end
