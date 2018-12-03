require_relative 'maths.rb'
require_relative 'reader.rb'
require_relative 'argschecker'
require_relative 'rpncal'
require_relative 'letoperation'

# check if path(file to read)
arg_checker = ArgsChecker.new
@check = arg_checker.check_args ARGV
@read_lines = []
@mode = 1
@final_result = 0
@print_flag = 0

# path was provided
if @check.zero?
  # for x in ARGV
  ARGV.each do |x|
    File.open(x, 'r') do |f|
      f.each_line do |line|
        @read_lines.push(line)
        # puts line
      end
    end
  end
  @mode = 0
end
# read from file
# exit 0
# no path provided enter REPL
# else
# REPL
# keep track of line#
line_number = 1

# init hash for let keyword
# store variable values in this hash map
definitions = {}
@i = 0

# while true
loop do
  if @mode == 1
    print '> '
    STDOUT.flush
    # parse input
    cmd = gets
  else
    cmd = @read_lines[@i]
    break unless @read_lines.length != @i
    @i += 1
  end

  k = ReaderFunctions.new cmd, line_number

  # check for empty input
  if k.empty?
    # continue to the next iteration
    line_number += 1
    next
  end

  # get front word(keyword)
  keyword = k.getkeyword
  # check for valid keyword
  # evaluate
  case keyword
  when 'let'
    # store definition from return of LET
    # manage the operations in the clas LET
    tuple = LET.new cmd, line_number, definitions
    rtrnval = tuple.handle @mode

    # if variable not initialized
    exit rtrnval if (rtrnval == 1 || rtrnval == 5) && @mode.zero?
    definitions = tuple.hashm
    # definitions.each do |key, value|
    #   puts "#{key}:#{value}"
    # end
  when 'quit'
    exit
  else
    # no cmd provided
    # check for invalid cmd/variable/or number
    if (keyword != 'print') && (!(k.num? keyword) && !(k.valid_var? keyword))
      puts 'Line ' + k.line_num.to_s + ': Unknown keyword: ' + keyword.upcase
      exit 4 if @mode.zero?
    else
      cmd = cmd[5..cmd.length] if keyword == 'print' && cmd.length > 5
      # the first argument is a number
      # try to execute RPN
      # check if valid format operation
      # select print flag
      @printflag =  if keyword == 'print'
                      1
                    else
                      0
                    end

      rpn_operation = RPNcal.new cmd, line_number, definitions
      rtrn = rpn_operation.compute @mode, @printflag
      # applied to empty stack
      # unintialized variable
      # more elements than needed
      exit rtrn if (rtrn == 1 || rtrn == 2 || rtrn == 3) && @mode.zero?
      @final_result = rpn_operation.rslt
    end
  end
  # repeat
  # increase stored line
  line_number += 1
  break unless keyword != 'quit'
end

puts @final_result if @mode.zero? && @printflag.zero?
