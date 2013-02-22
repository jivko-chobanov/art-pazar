class CartController
  def initialize(first_product)
    @pipe, @cart, @products = Pipe.new, Main::Carts.new, [first_product]
  end

  private

  def save_in_cart(cart_hash)
    @cart.set cart_hash
    @type = @cart.type
    @id = @cart.id
  end
end
