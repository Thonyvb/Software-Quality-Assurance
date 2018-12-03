# Class rpncal do the actual math
class RPNcal
  attr_accessor :rslt
  def initialize(line, num, hashm)
    @op = if (line.length > 1) && !line.is_a?(Array)
            line.split(' ').map(&:to_s)
          else
            line
          end
    @ln = num
    @stack = []
    @current_var = 0
    @hash = hashm
  end

  def check_stack
    return 0 unless @op.empty?
    puts "Line #{@ln}: Empty Stack"
    1
  end

  def compute(mode, printflag)
    return 1 if check_stack == 1
    @op.each do |i|
      k = i.downcase
      if num_or_init? k
        i = @hash[k] if valid_var? k
        @stack.push(i.to_i)
      elsif i == '+'
        return 2 if add == false
      elsif i == '-'
        return 2 if subtract == false
      elsif i == '*'
        return 2 if multiply == false
      elsif i == '/'
        return 2 if division == false
      else
        error(i)
        return 1
      end
    end
    end_result(mode, printflag)
  end

  def end_result(mode, printflag)
    if @stack.count == 1
      @rslt = @stack.pop
      puts @rslt if mode == 1 || printflag == 1
    else
      puts "Line #{@ln}: #{@stack.count} elements in stack after evaluation"
      3
    end
  end

  def error(idx)
    if valid_var? idx
      puts "Line #{@ln}: Variable #{idx} is not initialized."
      return 1
    else
      puts "Line #{@ln}: Could not evaluate expression: #{idx} "
    end
    1
  end

  # checks if input is an integer
  def num_or_init?(line)
    if line =~ /\A[-+]?[0-9]+\z/
      true
    # check value is defined in hash map of variables definitions
    elsif @hash.key?(line)
      true
    else false
    end
  end

  # check if input is a valid variable
  def valid_var?(line)
    if line =~ /^\s*[a-zA-Z]/ && line.length == 1
      true
    else
      false
    end
  end

  def add
    firsoperand = @stack.pop
    if num_or_init? @stack[0].to_s
      secondoperand = @stack.pop
    else
      puts "Line #{@ln}: Operator + applied to empty stack"
      return false
    end
    @stack.push(firsoperand + secondoperand)
  end

  def subtract
    firsoperand = @stack.pop
    if num_or_init? @stack[0].to_s
      secondoperand = @stack.pop
    else
      puts "Line #{@ln}: Operator - applied to empty stack"
      return false
    end
    @stack.push(secondoperand - firsoperand)
  end

  def multiply
    firsoperand = @stack.pop
    if num_or_init? @stack[0].to_s
      secondoperand = @stack.pop
    else
      puts "Line #{@ln}: Operator * applied to empty stack"
      return false
    end
    @stack.push(firsoperand * secondoperand)
  end

  def division
    firsoperand = @stack.pop
    if num_or_init? @stack[0].to_s
      secondoperand = @stack.pop
    else
      puts "Line #{@ln}: Operator * applied to empty stack"
      return false
    end
    @stack.push(secondoperand / firsoperand)
  end
end
