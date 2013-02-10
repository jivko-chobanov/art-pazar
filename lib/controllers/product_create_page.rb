class ProductCreatePage < UpdateOrCreatePage
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
  
  def accomplish
    super do
      create_data_obj_using_params @product, "_p"
      create_data_obj_using_params @product_specifications, "_ps"
      true
    end
  end

  def load_and_do(product_type)
    load product_type
    accomplish
  end
  
  private

  def create_data_obj_using_params(data_object, params_suffix)
    data_object.create @pipe.get :params,
      {names: data_object.attributes_of(:for_create),
      suffix: params_suffix}
  end
end
