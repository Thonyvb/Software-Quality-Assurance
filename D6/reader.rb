# reads string input
class ReaderFunctions
  attr_accessor :str, :line_num

  # intialize class
  def initialize(line, num)
    @str = line.split(' ').map(&:to_s)
    @line_num = num
  end

  # checks if num is integer
  def num?(line)
    if line =~ /\A[-+]?[0-9]+\z/
      true
    else
      false
    end
  end

  def valid_var?(line)
    if line =~ /^\s*[a-zA-Z]/ && line.length == 1
      true
    else
      false
    end
  end

  def getkeyword
    @str[0].downcase
  end

  def empty?
    if @str.count < 1 || @str == ' ' || @str == '\n'
      true
    else
      false
    end
  end
end
