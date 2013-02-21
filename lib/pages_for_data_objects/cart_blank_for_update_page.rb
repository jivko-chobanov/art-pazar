class CartBlankForUpdatePage < Page
  attr_reader :pipe

  def initialize
    @pipe = Pipe.new
    @cart = Main::Carts.new @pipe
  end

  def load(id = nil)
    super() do
      @cart.load_from_db id: id, attribute_group: :for_update, limit: 1 
    end
  end

  def html
    super do
      @pipe.get(:html_for_update, data_by_type: {
        @cart.data_obj_name => @cart.loaded_as_hashes,
      })
    end
  end

  def pipe_name_of_txt_if_empty_content
    @cart.loaded_empty_result? ? :no_cart : false
  end

  def load_and_get_html(hash_with_id)
    load hash_with_id[:id]
    html
  end
end
