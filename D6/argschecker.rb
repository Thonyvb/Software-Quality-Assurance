# Class ArgsChecker check number of input arguments
class ArgsChecker
  def check_args(val)
    if val.count > 0
      0
    else
      -1
    end
  end
end
