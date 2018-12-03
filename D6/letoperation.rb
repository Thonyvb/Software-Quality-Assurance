require_relative 'rpncal'
require_relative 'reader'

# Class LET handles variable definitions
class LET
  attr_accessor :hashm
  def initialize(line, num, hashmt)
    @line = lines
    @l = line.split(' ').map(&:to_s)
    @ln = num
    @hashm = hashmt
    @reader = ReaderFunctions.new @line, @ln
    @valid_var = ''
  end

  def handle(mode)
    if @l.length <= 2
      puts "Line #{@ln}: LET applied to empty stack unable to initialize"
      5
    else
      check_var
      do_math(mode)
      9
    end
  end

  def do_math(mode)
    definition = @l[2..@l.length]
    calculator = RPNcal.new definition, @ln, @hashm
    rtrn = calculator.compute mode, 0
    exit rtrn if (rtrn == 1 || rtrn == 2 || rtrn == 3) && mode.zero?
    @hashm[@valid_var] = calculator.rslt unless calculator.rslt.nil?
  end

  def check_var
    if @reader.valid_var? @l[1]
      @valid_var = @l[1].downcase
    else
      puts "Line #{@ln}: LET #{@l[1]} is invalid: not a valid variable"
      1
    end
  end
end
