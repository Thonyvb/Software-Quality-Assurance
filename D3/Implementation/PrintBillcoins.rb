class PrintBillcoins
	def printcoins people
		people.each do |key, val|
			if key != "SYSTEM"
				puts "#{key}:  #{val} billcoins!"
			end
		end
	end
end


	