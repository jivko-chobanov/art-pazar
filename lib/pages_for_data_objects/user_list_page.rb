class UserListPage < Page

  def initialize
    @users = Main::Users.new
    super
  end

  def load
    super do
      @users.load_from_db(
        attribute_group: :list_for_admin,
        order: :last,
        limit: 10
      )
    end
  end

  def html
    super { @users.html }
  end

  def pipe_name_of_txt_if_empty_content
    @users.loaded_empty_result? ? :no_users : false
  end
end
