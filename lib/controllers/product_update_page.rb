class ProductUpdatePage < UpdateOrCreatePage
  def initialize
    @product = Main::Products.new
  end

  def load
    super do
      @product.load attribute_group: :for_update, limit: 1 
    end
  end

  def html
    super { @product.html_for_update }
  end

  def pipe_name_of_txt_if_empty_content
    @product.loaded_empty_result? ? :no_product : false
  end
end
