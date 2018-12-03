require_relative 'Driver'

class Stats
	def print_stats driver
		print_books driver
		print_classes driver
		print_toys driver
	end

	def print_books driver
		if driver.books == 1
			puts driver.to_s + " obtained 1 book!" 
		else
			puts driver.to_s + " obtained " + driver.books.to_s + " books!" 
		end
	end

	def print_classes driver
		if driver.classes == 1
			puts driver.to_s + " obtained 1 class!" 
		else
			puts driver.to_s + " obtained " + driver.classes.to_s + " classes!"
		end
	end

	def print_toys driver
		if driver.dinousar_toys == 1
			puts driver.to_s + " obtained 1 dinosaur toy!" 
		else
			puts driver.to_s + " obtained " + driver.dinousar_toys.to_s + " dinosaur toys!"
		end
	end

end