require(__FILE__.split('art_pazar/').first << '/art_pazar/lib/lib_loader.rb')

class Home
  attr_reader :tried_to_load

  def initialize
    @products = Main::Products.new
    @tried_to_load = false
  end

  def load
    unless @tried_to_load
      @tried_to_load = true
      @products.get(
        attribute_group: :list,
        order: :last,
        limit: 10
      )
    else
      raise "cannot load home twice"
    end
  end

  def html
    if @products.initialized_only?
      raise "Home page cannot generate HTML without data to be loaded first."
    elsif @products.loaded_empty_result?
      Pipe.get :txt, txt: :no_products_for_home_page
    else
      @products.html
    end
  end
end
