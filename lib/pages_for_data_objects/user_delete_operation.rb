class UserDeleteOperation < Operation
  attr_reader :pipe

  def initialize
    @pipe = Pipe.new
    @user = Main::Users.new @pipe
  end

  def load(id)
    super()
  end

  def accomplish(id)
    super() do
      @user.delete id
    end
  end

  def load_and_accomplish(hash_with_user_id)
    load hash_with_user_id[:id]
    accomplish hash_with_user_id[:id]
  end
end
