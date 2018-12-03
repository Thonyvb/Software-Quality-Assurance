require 'minitest/autorun'
require 'pathname'

require_relative 'ArgsChecker'
require_relative 'HashGenerator'
require_relative 'ErrorReport'
require_relative 'OrderChecker'
require_relative 'TransactionChecker'
require_relative 'TimeChecker'
require_relative 'PrevHashChecker'
require_relative 'HashChecker'
require_relative 'PrintBillcoins'

class VerifierTest < Minitest::Test

	# This unit test verifies that when no value is passed from the command line the Program outputs error mssg
	# EDGE CASE
	def test_no_args
	   args_checker = ArgsChecker::new
	   assert_output(/Usage: ruby verifier.rb <file>/) { args_checker.check_args []}
	end  

	# This unit test verifies that when if more than 1 value is passed from the command line the Program outputs error mssg
	# EDGE CASE
	def test_two_args
	   args_checker = ArgsChecker::new
	   assert_output(/Usage: ruby verifier.rb <file>/) { args_checker.check_args ["hello", "hi"]}
	end  

	# This unit test verifies that when a file does not exist the Program outputs error mssg
	# EDGE CASE
	def test_no_file
	   args_checker = ArgsChecker::new
	   pn = Pathname.new('aklsdfadfjakdf.adsljkfaj')
	   assert_output(/file does not exist/) { args_checker.check_file_existance pn}
	end  

	# This unit test verifies that the correct error is Displayed to the user 
	def test_error_report
	   an_error = ErrorReport::new
	   lno = 1
	   i = 2
	   assert_output(/Line 1:  Invalid block number 1, should be 2\nBLOCKCHAIN INVALID\n/) { an_error.report "Line #{lno}", " Invalid block number #{lno}, should be #{i}"}
	end  

	# This unit test verifies that the correct billcoins are print to user 
	def test_billcoins
	   people = {"George"=>100}
	   bill_report = PrintBillcoins::new
	   assert_output(/George:  100 billcoins!/) { bill_report.printcoins people}
	end  

	# This unit test verifies that the correct error is Displayed to the user id the blocs are not in order
	def test_wrong_order
		order_check = OrderChecker::new
		history = ["0|1c12|SYSTEM>George(100)|1518892051.740967000|abb2",
					"9|abb2|George>Amina(16):Henry>James(4):Henry>Cyrus(17):Henry>Kublai(4):George>Rana(1):SYSTEM>"] 
		assert_output(/Line 9:  Invalid block number 9, should be 1\nBLOCKCHAIN INVALID\n/) { order_check.verify_order history }
	end  

	# This unit test verifies that the test passes if blocks are in order
	def test_correct_order
		order_check = OrderChecker::new
		history = ["0|1c12|SYSTEM>George(100)|1518892051.740967000|abb2",
					"1|abb2|George>Amina(16):Henry>James(4):Henry>Cyrus(17):Henry>Kublai(4):George>Rana(1):SYSTEM>"] 
		assert_output("") { order_check.verify_order history }
	end  

	# This unit test verifies that the correct error is Displayed to the user if time is not increased properly
	def test_nanoseconds
		time_check = TimeChecker::new
		history = ["6|d072|Wu>Edward(16):SYSTEM>Amina(100)|1518892051.793695000|949",
					"7|949|Louis>Louis(1):George>Edward(15):Sheba>Wu(1):Henry>James(12):Amina>Pakal(22):SYSTEM>Kublai(100)|1518892051.199497000|1e5c"] 
		assert_output(/Line 7:  Previous timestamp 1518892051.793695000 >= new timestamp 1518892051.199497000\nBLOCKCHAIN INVALID\n/) { time_check.check_time  history }
	end  

	# This unit test verifies that the correct error is Displayed to the user if time is not increased properly
	def test_wrong_seconds
		time_check = TimeChecker::new
		history = ["7|949|Louis>Louis(1):George>Edward(15):Sheba>Wu(1):Henry>James(12):Amina>Pakal(22):SYSTEM>Kublai(100)|1518892053.799497000|f944", "8|f944|SYSTEM>Tang(100)|1518892051.812065000|775a"]
		assert_output(/Line 8:  Previous timestamp 1518892053.799497000 >= new timestamp 1518892051.812065000\nBLOCKCHAIN INVALID\n/) { time_check.check_time history }
	end  

	# This unit test verifies that the test passes if time is increased properly
	def test_correct_seconds
		time_check = TimeChecker::new
		history = ["7|949|Louis>Louis(1):George>Edward(15):Sheba>Wu(1):Henry>James(12):Amina>Pakal(22):SYSTEM>Kublai(100)|1518892053.799497000|f944", "8|f944|SYSTEM>Tang(100)|1518892056.812065000|775a"]
		assert_output("") { time_check.check_time history }
	end  

	# This unit test verifies that the correct error is Displayed to the user if time is not increased properly
	def test_wrong_prev_hash
		prev_hash_check = PrevHashChecker::new
		history = ["6|d072|Wu>Edward(16):SYSTEM>Amina(100)|1518892051.793695000|949", "7|6666|Louis>Louis(1):George>Edward(15):Sheba>Wu(1):Henry>James(12):Amina>Pakal(22):SYSTEM>Kublai(100)|1518892051.799497000|32aa"]
		assert_output(/Line 6: Previous hash was d072, should be 949\nBLOCKCHAIN INVALID\n/) { prev_hash_check.verify_prev history }
	end  

	# This unit test verifies that the test passes if correct previous hash are stored
	def test_correct_prev_hash
		prev_hash_check = PrevHashChecker::new
		history = ["0|0|SYSTEM>George(100)|1518892051.740967000|abb2", "1|abb2|George>Amina(16):Henry>James(4):Henry>Cyrus(17):Henry>Kublai(4):George>Rana(1):SYSTEM>Wu(100)|1518892051.753197000|c72d"]
		assert_output("") { prev_hash_check.verify_prev history }
	end  
end