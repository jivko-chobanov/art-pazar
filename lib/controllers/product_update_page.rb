class ProductUpdatePage < UpdateOrCreatePage
  def initialize
    @product = Main::Products.new
    @product_specifications = Main::ProductSpecifications.new
    @pipe = Pipe.new
  end

  def load
    super do
      @product.load attribute_group: :for_update, limit: 1 
      @product_specifications.type = @product.type
      @product_specifications.load attribute_group: :for_update, limit: 1 
    end
  end

  def html
    super do
      @pipe.get :html_for_update, data_by_type: @product.loaded_data_hash_for_update.merge(
        @product_specifications.loaded_data_hash_for_update
      )
    end
  end

  def pipe_name_of_txt_if_empty_content
    @product.loaded_empty_result? ? :no_product : false
  end
end
