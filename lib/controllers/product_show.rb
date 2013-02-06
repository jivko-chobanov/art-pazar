class ProductShow
  include ShowPage

  def initialize
    @product = Main::Products.new
  end

  def load
    load_show_page do
      @product.load attribute_group: :for_visitor, limit: 1 
    end
  end

  def html
    html_of_show_page(pipe_name_of_txt_if_empty_content) { @product.html }
  end

  def pipe_name_of_txt_if_empty_content
    @product.loaded_empty_result? ? :no_product : false
  end
end
