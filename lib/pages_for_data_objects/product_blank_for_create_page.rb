class ProductBlankForCreatePage < Page
  attr_reader :pipe

  def initialize
    @pipe = Pipe.new
    @product = Main::Products.new @pipe
    @product_specifications = Main::ProductSpecifications.new @pipe
  end

  def load(product_type)
    super() do
      @product_specifications.type = product_type
    end
  end

  def html
    super do
      @pipe.get(:html_for_create, data_by_type: {
        @product.data_obj_name => @product.attributes_of(:for_create),
        @product_specifications.data_obj_name => @product_specifications.attributes_of(:for_create)
      })
    end
  end

  def pipe_name_of_txt_if_empty_content
    false
  end

  def load_and_get_html(hash_with_product_type)
    load hash_with_product_type[:product_type]
    html
  end
end
