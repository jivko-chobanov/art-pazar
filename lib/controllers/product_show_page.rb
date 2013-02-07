class ProductShowPage < ShowPage
  def initialize(product_type)
    @product = Main::Products.new
    @product_specifications = Main::ProductSpecifications.new product_type
    @pipe = Pipe.new
  end

  def load
    super do
      @product.load attribute_group: :for_visitor, limit: 1 
      @product_specifications.load attribute_group: :for_visitor, limit: 1 
    end
  end

  def html
    super do
      @pipe.get :html, data_by_type: @product.loaded_data_hash.merge(@product_specifications.loaded_data_hash)
    end
  end

  def pipe_name_of_txt_if_empty_content
    @product.loaded_empty_result? ? :no_product : false
  end
end
