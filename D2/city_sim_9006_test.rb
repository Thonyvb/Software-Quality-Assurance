require 'minitest/autorun'

require_relative 'Driver'
require_relative 'ArgsChecker'
require_relative 'SeedChecker'
require_relative 'Stats'
require_relative 'CitySim'
require_relative 'RandomGenerator'

class CitySimTest < Minitest::Test
	def setup
		@driver = Driver::new 1, 1
	end

	# This unit test verifies that creating a Driver is an instance of Driver and not
	# something else.
	def test_driver_is_driver
		assert @driver.is_a?(Driver)
	end

	# This unit test verifies that when no value is passed from the command line the Program raises
	# the appropriate exception
	# EDGE CASE
	def test_args_none
	   args_checker = ArgsChecker::new
	   exception = assert_raises(Exception) { args_checker.check_args [] }
	   assert_equal( "Enter a seed and only a seed", exception.message )
	end

	# This unit test verifies that more than one value is passed from the command line the Program raises
	# the appropriate exception
	# EDGE CASE
	def test_args_exceed
	   args_checker = ArgsChecker::new
	   exception = assert_raises(Exception) { args_checker.check_args [1,2] }
	   assert_equal( "Enter a seed and only a seed", exception.message )
	end

	# UNIT TESTS FOR METHOD check_seed val
	# Equivalence classes:
	# val= ["2"]-> returns 2
	# val= ["-2"]-> returns 0
	# val= (not a number) -> returns 0

	# This unit test verifies that when a valid seed is passed from command line the seed is indeed the same value
	def test_args_positive_seed
		s = SeedChecker::new
		arr = ["2"]
		s.check_seed arr
		assert_equal("2", s.seed_ret.to_s) 
	end

	# This unit test verifies that when a negative seed is passed from command line the seed is 0
	def test_args_negative_seed
		s = SeedChecker::new
		arr = ["-2"]
		s.check_seed arr
		assert_equal("0", s.seed_ret.to_s) 
	end

	# This unit test verifies that when an invalid seed is passed from command line 
	# the seed is 0
	def test_args_not_valid
		s = SeedChecker::new
		arr = ["hello"]
		s.check_seed arr
		assert_equal("0", s.seed_ret.to_s) 
	end

	# This unit test verifies that the books increases when increase_of_books method is triggered.
	def test_increase_of_books
		mock = Minitest::Mock.new("test_increase")

		def mock.books; 10 ; end
		def mock.set_books a; books = a; end

		game = CitySim::new
		num = game.increase_books mock
		assert_equal 11, num
	end

	# This unit test verifies that the classes are doubled when increase_class method is triggered.
	def test_increase_of_class
		mock = Minitest::Mock.new("test_increase")

		def mock.classes; 10 ; end
		def mock.set_classes a; classes = a; end

		game = CitySim::new
		num = game.increase_class mock
		assert_equal 20, num
	end

	# This unit test verifies that the dinousar toys increase when increase_toys method is triggered.
	def test_increase_of_toys
		mock = Minitest::Mock.new("test_increase")

		def mock.dinousar_toys; 10 ; end
		def mock.set_dinousar_toys a; dinousar_toys = a; end

		game = CitySim::new
		num = game.increase_toys mock
		assert_equal 11, num
	end

	# This unit test verifies that the correct number of books are indeed printed to the user 
	def test_print_books
		@driver.set_books 2
		output = Stats::new 
		assert_output(/Driver 1 obtained 2 books!/) { output.print_books @driver}
	end 

	# This unit test verifies that correct grammar (singular) is used when printing the number of books: book instead of books
	# EDGE CASE
	def test_print_book
		@driver.set_books 1
		output = Stats::new 
		assert_output(/Driver 1 obtained 1 book!/) { output.print_books @driver}
	end   

	# This unit test verifies that the correct number of classes are indeed printed to the user 
	def test_print_classes
		@driver.set_classes 2
		output = Stats::new 
		assert_output(/Driver 1 obtained 2 classes!/) { output.print_classes @driver}
	end 

	# This unit test verifies that correct grammar (singular) is used when printing the number of classes: class instead of classes
	# EDGE CASE
	def test_print_class
		@driver.set_classes 1
		output = Stats::new 
		assert_output(/Driver 1 obtained 1 class!/) { output.print_classes @driver}
	end 

	# This unit test verifies that the correct number of toys are indeed printed to the user 
	def test_print_toys
		@driver.set_dinousar_toys 2
		output = Stats::new 
		assert_output(/Driver 1 obtained 2 dinosaur toys!/) { output.print_toys @driver}
	end 

	# This unit test verifies that correct grammar (singular) is used when printing the number of toys: toy instead of toys
	# EDGE CASE
	def test_print_toy
		@driver.set_dinousar_toys 1
		output = Stats::new 
		assert_output(/Driver 1 obtained 1 dinosaur toy!/) { output.print_toys @driver}
	end 

	# This unit test verifies that valid moves are executed following the game rules if we start at the hospital
	def test_moves_hospital
		mock = Minitest::Mock.new("random_number")
		def mock.get_loc a, b; 1 ; end
		game = CitySim::new
		str = "Driver 1"
		num = game.moves str, mock, 0, @driver
		assert_equal 1, num
		assert_output(/Driver 1 heading from Hospital to Cathedral via Fourth Ave./) { game.moves str, mock, 0, @driver}
	end

	# This unit test verifies that valid moves are executed following the game rules if we start at the cathedral
	def test_moves_cathedral
		mock = Minitest::Mock.new("random_number")
		def mock.get_loc a, b; 3 ; end
		game = CitySim::new
		str = "Driver 1"
		num = game.moves str, mock, 1, @driver
		assert_equal 3, num
		assert_output(/Driver 1 heading from Cathedral to Museum via Bar St./) { game.moves str, mock, 1, @driver}
	end


	# This unit test verifies that valid moves are executed following the game rules if we start at hillman
	def test_moves_hillman
		mock = Minitest::Mock.new("random_number")
		def mock.get_loc a, b; 0 ; end
		game = CitySim::new
		str = "Driver 1"
		num = game.moves str, mock, 2, @driver
		assert_equal 0, num
		assert_output(/Driver 1 heading from Hillman to Hospital via Foo St./) { game.moves str, mock, 2, @driver}
	end

	# This unit test verifies that valid moves are executed following the game rules if we start at the museum
	def test_moves_museum
		mock = Minitest::Mock.new("random_number")
		def mock.get_loc a, b; 1 ; end
		game = CitySim::new
		str = "Driver 1"
		num = game.moves str, mock, 3, @driver
		assert_equal 1, num
		assert_output(/Driver 1 heading from Museum to Cathedral via Bar St./) { game.moves str, mock, 3, @driver}
	end
end
