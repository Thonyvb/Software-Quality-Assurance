require_relative 'Driver'
require_relative 'ArgsChecker'
require_relative 'SeedChecker'
require_relative 'Stats'
require_relative 'RandomGenerator'


class CitySim
	def increase_books cb_driver 
		cb_driver.set_books cb_driver.books+1
	end

	def increase_class c_driver 
		c_driver.set_classes c_driver.classes*2
	end

	def increase_toys t_driver 
		t_driver.set_dinousar_toys t_driver.dinousar_toys+1
	end

	def make_driver name_d, location 
		a_driver = Driver::new name_d, location
	end

	def moves str, rnd, loc, current_driver 
		hospital = 0
		cathedral = 1
		hillman = 2
		museum = 3
		monroeville = 4
		downtown = 5

		str_c = " "
		@loc = loc

		case @loc
		when hospital
			@loc = rnd.get_loc 1,2
			if @loc == cathedral
				str_c = " to Cathedral via Fourth Ave."
			elsif @loc == hillman
				str_c = " to Hillman via Foo St."
			end

			current_driver.location = @loc
			puts str +" heading from Hospital"+str_c
			return @loc

		when cathedral 
			@loc = rnd.get_loc 3,4
			increase_class current_driver

			if @loc == museum
				str_c = " to Museum via Bar St."
			elsif @loc == monroeville
				str_c = " to Monroeville via Fourth Ave."
			end

			current_driver.location = @loc
			puts str + " heading from Cathedral" + str_c
			return @loc

		when hillman
			@loc = rnd.get_loc 0,1
			increase_books current_driver
			if @loc == hospital
				str_c = " to Hospital via Foo St."
			elsif @loc == 1
				@loc = downtown
				str_c = " to Downtown via Fifth Ave."
			end

			current_driver.location = @loc
			puts str + " heading from Hillman" + str_c
			return @loc

		when museum
			@loc = rnd.get_loc 1,2
			increase_toys current_driver

			if @loc == cathedral
				str_c = " to Cathedral via Bar St."
			elsif @loc == hillman
				str_c = " to Hillman via Fifth Ave."
			end

			current_driver.location = @loc
			puts str + " heading from Museum" + str_c
			return @loc
		else
			raise "invalid location"
		end
	end


	def gameloop
		arg_checker = ArgsChecker::new
		arg_checker.check_args ARGV
		seed_checker = SeedChecker::new
		seed_checker.check_seed ARGV

		rnd = RandomGenerator::new seed_checker.seed_ret

		# City Map: Where each location is encoded with a number from 0-5
		#	
		#                 ---> [Hospital(0)] ----> [Cathedral(1)] ----> Fourth Ave. (to Monroeville) (4)
		#                  		     ^  |              ^  |
		#               	Foo St.  |  |              |  | Bar St.
		#                      		 |  V              |  V
		#  (to Downtown(5))  <--- [Hillman(2)]  <---- [Museum(3)] <--- Fifth Ave.

		for j in 1..5 do
			@loc = rnd.get_loc 0,3
			current_driver = make_driver j, @loc
			str = current_driver.to_s

			while (@loc != 4) && (@loc != 5)
				@loc = moves(str, rnd, @loc, current_driver)
			end
			#obtain and print the game results
			stat_print = Stats::new
			stat_print.print_stats current_driver
		end
	end
end