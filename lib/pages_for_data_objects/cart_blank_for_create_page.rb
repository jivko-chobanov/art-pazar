class CartBlankForCreatePage < Page
  attr_reader :pipe

  def initialize
    @pipe = Pipe.new
    @cart = Main::Carts.new @pipe
  end

  def load
    super()
  end

  def html
    super do
      @pipe.get(:html_for_create, data_by_type: {
        @cart.data_obj_name => @cart.attributes_of(:for_create),
      })
    end
  end

  def pipe_name_of_txt_if_empty_content
    false
  end

  def load_and_get_html(unused_arg = nil)
    load
    html
  end
end
