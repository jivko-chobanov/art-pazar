class CartUpdateOperation < Operation
  attr_reader :pipe

  def initialize
    @pipe = Pipe.new
    @cart = Main::Carts.new @pipe
  end

  def load
    super() do
      @cart.load_from_params attribute_group: :for_update
    end
  end

  def accomplish
    super do
      @cart.update
    end
  end
end
