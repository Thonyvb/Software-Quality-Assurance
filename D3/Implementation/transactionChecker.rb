require_relative 'ErrorReport'

class TransactionChecker
	def verify_transaction history
		i = 0
		people = {}
		people.default = 0
		an_error = ErrorReport::new

		for transaction in history
			newarr = transaction.split(/[\s|]+/)
			lno = newarr[0]
			item = newarr[2]
			transfers = item.split(/[\s:]+/)

			for agreement in transfers
				agreement = agreement.gsub!(/[^0-9A-Za-z]/, ' ')
				temp_arr = agreement.split()


				if temp_arr.length > 3
					an_error.report "Line #{lno}", "!!An invalid #{temp_arr.length} character was found on a line"
					exit
				end

				from = temp_arr[0]
				to = temp_arr[1]
				quantity = temp_arr[2]

				## Invalid address(> 6 alphabetic characters)
				## An invalid character was found on a line
				if from.length > 6 || to.length >6
					an_error.report "Line #{lno}", " An invalid address (> 6 alphabetic characters)"
					exit
				end

				if !(is_number? quantity)
					an_error.report "Line #{lno}", "An invalid character #{quantity} was found on a line"
					exit
				end

				quantity = quantity.to_i
				people[from] = people[from] - quantity
				people[to] = people[to] + quantity

				##Remeber to ignore SYSTEM since it is always negative
				##check this at the end of reading all transactions from bloc
			end

				people.each do |key, val|
					if val < 0 and key != "SYSTEM"
						an_error.report "Line #{lno}", "An invalid block, address #{key} has  #{val} billcoins!"
						exit
					end
				end

			i = i + 1;
		end
		
		return people
	end
end