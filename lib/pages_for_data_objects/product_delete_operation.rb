class ProductDeleteOperation < Operation
  attr_reader :pipe

  def initialize
    @pipe = Pipe.new
    @product = Main::Products.new @pipe
    @product_specifications = Main::ProductSpecifications.new @pipe
  end

  def load(id)
    super()
  end

  def accomplish(id)
    super() do
      @product.delete id
      @product_specifications.delete product_id: id
      true
    end
  end

  def load_and_accomplish(hash_with_product_type)
    load hash_with_product_type[:id]
    accomplish hash_with_product_type[:id]
  end
end
