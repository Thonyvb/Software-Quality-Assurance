# Note that we require and start simplecov before
# doing ANYTHING else, including other require statements.
require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require_relative 'rpncal'
require_relative 'argschecker'
require_relative 'reader'
require_relative 'letoperation'

class RpnTest < Minitest::Test

  # this unit test verifies that the rpncal method
  # recognized a valid variable
	def test_rpncal_valid_method
		acalc = RPNcal.new "1 2 3", 1, Hash.new
		valid_var = acalc.valid_var? "A"
		assert_equal true, valid_var
	end

  # this unit test verifies that the rpncal method
  # recognized an invalid variable
  # EDGE CASE
	def test_rpncal_wrong_valid_method
		acalc = RPNcal.new "1 2 3", 1, Hash.new
		valid_var = acalc.valid_var? "+012aasdfadf"
		assert_equal false, valid_var
	end

	# this unit test verifies that the rpncal
  # evaluates correctly a proper expression
	def test_rpncal_compute
		str = "10 10 * 5 5 * 0 0 * + +"
		calc = RPNcal.new str, 1, Hash.new
		calc.compute 0, 0
		assert_equal 125, calc.rslt
	end

  # this unit test verifies that the rpncal method
  # recognized an valid signed
  # EDGE CASE
  def test_num_or_init
    str = "10 10 * 5 5 * 0 0 * + +"
    calc = RPNcal.new str, 1, Hash.new 
    assert_equal true, calc.num_or_init?('+1')
  end

  # this unit test verifies that the rpncal
  # evaluates correctly an expression that involves
  # negative subtraction
  def test_subtract
    str = "1 2 3 4 5 - - - -"
    calc = RPNcal.new str, 1, Hash.new 
    assert_output(/3/){ calc.compute(1, 1) }
  end

  # this unit test verifies that the ArgsChecker
  # reports correctly if a path was not passed with flag -1
  def test_arguments
    argt = ArgsChecker.new
    c = []
    assert -1, argt.check_args(c)
  end

  # this unit test verifies that the LET operation
  # evaluates correctly an expression and defines the
  # variable properly
  def test_let_statement_defined
    let_e = LET.new "LET A 1 2 +", 1, Hash.new
    let_e.handle 1
    assert_equal 3, let_e.hashm['a']
  end

  # this unit test verifies that the LET operation
  # catches and reports an error when dealing with invalid expressions
  # EDGE CASE
  def test_let_wrong_expression
    let_e = LET.new "LET A 1 2", 1, Hash.new
    assert_output(/Line 1: 2 elements in stack after evaluation/){let_e.handle 1}
  end

  # this unit test verifies that the LET operation
  # catches and reports an error when dealing with invalid expressions
  # that contains an incomplete expression
  # EDGE CASE
  def test_let_empty_stack
    hashm = {'A':3}
    let_e = LET.new "LET a 1 *", 1, Hash.new
    assert_output("Line 1: Operator * applied to empty stack\n"){let_e.handle 1}
  end

  # this unit test verifies that the LET operation
  # catches and reports an error when dealing with invalid expressions
  # that does not contain a variable definition
  # EDGE CASE
  def test_let_unitialized_variable
    hashm = {}
    let_e = LET.new "LET a", 1, hashm
    assert_output("Line 1: LET applied to empty stack unable to initialize\n"){let_e.handle 1}
  end

  # this unit test verifies that the LET operation
  # catches and reports an error when dealing with invalid expressions
  # that does not contain a variable definition
  # EDGE CASE
  def test_let_invalids
    let_e = LET.new "LET 0123 0 999999999999999999999999999 -", 1, Hash.new
    assert_output(/Line 1: LET 0123 is invalid: not a valid variable/){let_e.handle 1}
  end

  def test_rpn_biginteger
    let_e = LET.new "LET a 0 999999999999999999999999999 -", 1, Hash.new
    assert_output(/-999999999999999999999999999/){let_e.handle 1}
  end

  def test_get_key_word
    reader = ReaderFunctions.new('PrInT a', 1)
    assert_equal 'print', reader.getkeyword
  end

  def test_invalid_location_of_let
    calc = RPNcal.new "1 2 + PRINT 3", 1, Hash.new 
    assert_output(/Line 1: Could not evaluate expression: PRINT/){ calc.compute(1, 1) }
  end

  def test_input_is_num
    reader = ReaderFunctions.new(' ', 1)
    assert_equal true, reader.num?("-9192399399391929349193493491934")
  end

  def test_input_is_valid_var
    reader = ReaderFunctions.new('', 1)
    assert_equal false, reader.num?("AZD")
  end

  def test_empty
    reader = ReaderFunctions.new(' ', 1)
    assert_equal true, reader.empty?
  end

  def test_line_indexing
    line_number = 6
    calc = RPNcal.new "1 2 + PRINT 3", line_number, Hash.new 
    assert_output(/Line 6: Could not evaluate expression: PRINT/){ calc.compute(1, 1) }
  end
end
