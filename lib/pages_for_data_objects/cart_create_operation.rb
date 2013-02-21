class CartCreateOperation < Operation
  attr_reader :pipe

  def initialize
    @pipe = Pipe.new
    @cart = Main::Carts.new @pipe
  end

  def load
    super() do
      @cart.load_from_params attribute_group: :for_create
    end
  end

  def accomplish
    super do
      @cart.create
    end
  end

  def load_and_accomplish(unused_arg = nil)
    load
    accomplish
  end
end
