class CartController
  def initialize
    @pipe, @cart = Pipe.new, Main::Carts.new
    @products_in_cart = Main::ProductsInCart.new
    add_product_or_raise
    @cart.load_and_create
  end

  def add_product_from_params
    add_product_or_raise
  end

  def products_count
    @products_in_cart.size
  end

  def update_quantity(id_and_new_quantity)
    unless id_and_new_quantity.include? :id and id_and_new_quantity.include? :quantity
      raise "id_and_new_quantity arg is #{id_and_new_quantity} and is missing something"
    end

    @products_in_cart.each do |runtime_table_row|
      unless runtime_table_row.to_hash.include? :id
        raise "Products in cart do not have ids"
      end

      if runtime_table_row.to_hash[:id] == id_and_new_quantity[:id]
        return Main::ProductsInCart.new.update id_and_new_quantity
      end
    end
    raise "Could not find product_in_cart_id: #{id_and_new_quantity[:id]}"
  end

  def remove(id)
    if @products_in_cart.delete id
      products_count == 1 ? @cart.delete : true
    else
      false
    end
  end

  private

  def add_product_or_raise
    unless @products_in_cart.load_and_create
      raise "Cannot add product from params into the cart."
    end
  end
end
