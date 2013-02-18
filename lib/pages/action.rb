class Action
  def initialize
    @is_loaded = false
  end

  def load
    unless loaded?
      @is_loaded = true
      yield if block_given?
    else
      raise "cannot load action twice"
    end
  end

  def loaded?
    @is_loaded
  end
end
