class ProductListPage < Page

  def initialize
    @products = Main::Products.new
    super
  end

  def load
    super do
      @products.load_from_db(
        attribute_group: :list,
        order: :last,
        limit: 10
      )
    end
  end

  def html
    super { @products.html }
  end

  def pipe_name_of_txt_if_empty_content
    @products.loaded_empty_result? ? :no_products : false
  end
end
