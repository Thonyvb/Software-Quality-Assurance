# has the math functions
class MathFunctions
  # initlize instance vars
  def initialize(var)
    @num = var
  end

  # simple addition
  def add(var)
    @num += var
  end

  # simple substraction
  def substract(var)
    @num -= var
  end

  # simple divison
  def div(var)
    raise 'Divide by 0 error' if var.zero?
    @num /= var
  end

  # simple multiplication
  def mul(var)
    @num *= var
  end

  # return var
  def val
    @num
  end
end
