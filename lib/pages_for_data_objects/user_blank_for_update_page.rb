class UserBlankForUpdatePage < Page
  attr_reader :pipe

  def initialize
    @pipe = Pipe.new
    @user = Main::Users.new @pipe
  end

  def load(id = nil)
    super() do
      @user.load_from_db id: id, attribute_group: :for_update, limit: 1
    end
  end

  def html
    super do
      @pipe.get(:html_for_update, data_by_type: {
        @user.data_obj_name => @user.loaded_to_hashes,
      })
    end
  end

  def pipe_name_of_txt_if_empty_content
    @user.loaded_empty_result? ? :no_user : false
  end

  def load_and_get_html(hash_with_id)
    load hash_with_id[:id]
    html
  end
end
