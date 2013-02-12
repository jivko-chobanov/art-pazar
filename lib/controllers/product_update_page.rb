class ProductUpdatePage < UpdateOrCreatePage
  attr_reader :pipe

  def initialize
    @pipe = Pipe.new
    @product = Main::Products.new @pipe
    @product_specifications = Main::ProductSpecifications.new @pipe
  end

  def load(from, id = nil)
    case from
      when :from_db
        super() do
          @product.load_from_db id: id, attribute_group: :for_update, limit: 1 
          @product_specifications.load_from_db(
            id: id,
            type: @product.type,
            attribute_group: :for_update,
            limit: 1 
          )
        end
      when :from_params
        super() do
          @product.load_from_params attribute_group: :for_update
          @product_specifications.load_from_params attribute_group: :for_update, type: @product.type
        end
      else
        raise "Does not know how to load from #{from}"
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

  def accomplish
    super do
      @product.update 
      @product_specifications.update 
      true
    end
  end

  def load_and_accomplish
    load :from_params
    accomplish
  end

  def load_and_get_html(id)
    load :from_db, id
    html
  end
end
