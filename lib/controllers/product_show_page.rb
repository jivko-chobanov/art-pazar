class ProductShowPage < ShowPage
  def initialize
    @product = Main::Products.new
    @product_specifications = Main::ProductSpecifications.new
    @pipe = Pipe.new
  end

  def load(id)
    super() do
      @product.load_from_db id: id, attribute_group: :for_visitor, limit: 1 
      @product_specifications.load_from_db(
        id: id,
        type: @product.type,
        attribute_group: :for_visitor,
        limit: 1 
      )
    end
  end

  def html
    super do
      @pipe.get :html, data_by_type:
        @product.loaded_data_hash.merge(@product_specifications.loaded_data_hash)
    end
  end

  def pipe_name_of_txt_if_empty_content
    @product.loaded_empty_result? ? :no_product : false
  end
end
