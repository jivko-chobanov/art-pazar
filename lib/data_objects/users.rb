class User
  attr_reader :type

  def initialize
    @type = :visitor
    @pipe = Pipe.new
    @runtime_table = RuntimeTable.new
  end

  def login
    username_and_password = @pipe.get :params, names: %w{username password}
    user_hash = @pipe.get :runtime_table_hashes, {
      attribute_group: :for_login,
      username: username_and_password[:username],
      password: username_and_password[:password],
    }
    unless user_hash.empty?
      runtime_save user_hash
      @pipe.put :successful_authentication_in_session, {
        id: @runtime_table.row.id,
        type: @type,
      }
      true
    else
      false
    end
  end

  def identify_using_session
    user_hash = @pipe.get :successful_authentication_in_session
    if user_hash
      runtime_save user_hash
      true
    else
      false
    end
  end

  private

  def runtime_save(user_hash)
    @runtime_table.row << user_hash
    @type = @runtime_table.row.type
  end
end
