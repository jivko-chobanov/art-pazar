class ProductCreateOperation < Operation
  attr_reader :pipe

  def initialize
    @pipe = Pipe.new
    @product = Main::Products.new @pipe
    @product_specifications = Main::ProductSpecifications.new @pipe
  end

  def load(product_type)
    super() do
      @product_specifications.type = product_type
      @product.load_from_params attribute_group: :for_create
      @product_specifications.load_from_params attribute_group: :for_create, type: @product.type
    end
  end

  def accomplish
    super do
      @product.create
      @product_specifications.create @product.id
      true
    end
  end

  def load_and_accomplish(product_type)
    load product_type
    accomplish
  end
end
