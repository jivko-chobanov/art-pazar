class CartDetailsPage < Page
  def initialize
    @cart = Main::Carts.new
    @pipe = Pipe.new
  end

  def load(id)
    super() do
      @cart.load_from_db id: id, attribute_group: :details, limit: 1
    end
  end

  def html
    super do
      @pipe.get(:html, data_by_type: {
        @cart.data_obj_name => @cart.loaded_to_hashes,
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
