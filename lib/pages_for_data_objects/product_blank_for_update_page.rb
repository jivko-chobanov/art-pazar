class ProductBlankForUpdatePage < Page
  attr_reader :pipe

  def initialize
    @pipe = Pipe.new
    @product = Main::Products.new @pipe
    @product_specifications = Main::ProductSpecifications.new @pipe
  end

  def load(id = nil)
    super() do
      @product.load_from_db id: id, attribute_group: :for_update, limit: 1 
      @product_specifications.load_from_db(
        id: id,
        type: @product.type,
        attribute_group: :for_update,
        limit: 1 
      )
    end
  end

  def html
    super do
      @pipe.get(:html_for_update, data_by_type: {
        @product.data_obj_name => @product.loaded_as_hashes,
        @product_specifications.data_obj_name => @product_specifications.loaded_as_hashes
      })
    end
  end

  def pipe_name_of_txt_if_empty_content
    @product.loaded_empty_result? ? :no_product : false
  end

  def load_and_get_html(id)
    load id
    html
  end
end
