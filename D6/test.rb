require_relative 'maths.rb'
require_relative 'reader.rb'
m = MathFunctions.new 999_999_999_999_999_999_999_999_999
r = ReaderFunctions.new 'hello world', 1
puts m.val

puts r.num?('asd')
puts r.num?('a1s')
puts r.num?('1')
puts r.num?('222')
