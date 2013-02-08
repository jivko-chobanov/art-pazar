class ProductCreatePage < UpdateOrCreatePage
  def initialize
    @product = Main::Products.new
    @product_specifications = Main::ProductSpecifications.new
    @pipe = Pipe.new
  end

  def load(product_type)
    super() do
      @product_specifications.type = product_type
    end
  end

  def html
    super do
      @pipe.get :html_for_create, data_by_type: @product.loaded_data_hash_for_create.merge(
        @product_specifications.loaded_data_hash_for_create
      )
    end
  end

  def pipe_name_of_txt_if_empty_content
    false
  end

  def load_and_get_html(product_type)
    load product_type
    html
  end
end
