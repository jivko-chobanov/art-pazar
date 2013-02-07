class ProductCreatePage < UpdateOrCreatePage
  def initialize
    @product = Main::Products.new
  end

  def load
    super
  end

  def html
    super { @product.html_for_create }
  end

  def pipe_name_of_txt_if_empty_content
    false
  end
end
