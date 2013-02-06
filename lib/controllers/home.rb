class Home
  include ShowPage

  def initialize
    @products = Main::Products.new
    initialize_show_page
  end

  def load
    load_show_page do
      @products.load(
        attribute_group: :list,
        order: :last,
        limit: 10
      )
    end
  end

  def html
    html_of_show_page(pipe_name_of_txt_if_empty_content) { @products.html }
  end

  def pipe_name_of_txt_if_empty_content
    @products.loaded_empty_result? ? :no_products : false
  end
end
