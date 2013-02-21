class CartListPage < Page

  def initialize
    @carts = Main::Carts.new
    super
  end

  def load
    super do
      @carts.load_from_db(
        attribute_group: :list_for_admin,
        order: :last,
        limit: 10
      )
    end
  end

  def html
    super { @carts.html }
  end

  def pipe_name_of_txt_if_empty_content
    @carts.loaded_empty_result? ? :no_carts : false
  end
end
