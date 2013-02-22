class CartController
  def initialize
    @pipe, @cart = Pipe.new, Main::Carts.new(:single)
    @products = Main::ProductsInCart.new
    add_product_or_raise
    @cart.load_and_create
  end

  def add_product_from_params
    add_product_or_raise
  end

  def products_count
    @products.size
  end

# def

  private

  def add_product_or_raise
    unless @products.load_and_create
      raise "Cannot add product from params into the cart."
    end
  end
end
