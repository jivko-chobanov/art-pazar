class CartDeleteOperation < Operation
  attr_reader :pipe

  def initialize
    @pipe = Pipe.new
    @cart = Main::Carts.new @pipe
  end

  def load(id)
    super()
  end

  def accomplish(id)
    super() do
      @cart.delete id
    end
  end

  def load_and_accomplish(hash_with_cart_id)
    load hash_with_cart_id[:id]
    accomplish hash_with_cart_id[:id]
  end
end
