class Operation < Action
  def initialize
    super
  end

  def accomplish
    if loaded?
      yield
    else
      raise "load first"
    end
  end

  def load_and_accomplish(&to_accomplish)
    load
    accomplish &to_accomplish
  end
end
