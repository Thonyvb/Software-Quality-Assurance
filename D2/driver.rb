class Driver
  attr_accessor :name, :location

  def initialize name, location
    @name = name
    @books = 0
    @dinousar_toys = 0
    @classes = 1
    @location = location
  end

  def books
    @books
  end

  def set_books b
    @books = b
  end

  def classes
    @classes
  end

  def set_classes b
    @classes = b
  end

 def dinousar_toys
    @dinousar_toys
  end

  def set_dinousar_toys b
    @dinousar_toys = b
  end

  def to_s
    "Driver #{@name}"
  end

end