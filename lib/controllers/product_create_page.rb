class ProductCreatePage < UpdateOrCreatePage
  attr_reader :pipe

  def initialize
    @pipe = Pipe.new
    @product = Main::Products.new @pipe
    @product_specifications = Main::ProductSpecifications.new @pipe
  end

  def load(from, product_type)
    case from
      when :from_args
        super() do
          @product_specifications.type = product_type
        end
      when :from_params
        super() do
          @product_specifications.type = product_type
          @product.load_from_params attribute_group: :for_create
          @product_specifications.load_from_params attribute_group: :for_create, type: @product.type
        end
      else
        raise "Does not know how to load from #{from}"
    end
  end

  def html
    super do
      @pipe.get :html_for_create, data_by_type: @product.table_hash_for_create.merge(
        @product_specifications.table_hash_for_create
      )
    end
  end

  def pipe_name_of_txt_if_empty_content
    false
  end

  def load_and_get_html(product_type)
    load :from_args, product_type
    html
  end
  
  def accomplish
    super do
      @product.create
      @product_specifications.create @product.id
      true
    end
  end

  def load_and_accomplish(product_type)
    load :from_params, product_type
    accomplish
  end
end
