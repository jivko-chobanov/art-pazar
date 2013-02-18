class ProductUpdateOperation < Operation
  attr_reader :pipe

  def initialize
    @pipe = Pipe.new
    @product = Main::Products.new @pipe
    @product_specifications = Main::ProductSpecifications.new @pipe
  end

  def load
    super() do
      @product.load_from_params attribute_group: :for_update
      @product_specifications.load_from_params attribute_group: :for_update, type: @product.type
    end
  end

  def accomplish
    super do
      @product.update 
      @product_specifications.update 
      true
    end
  end
end
