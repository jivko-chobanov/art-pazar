class UserUpdateOperation < Operation
  attr_reader :pipe

  def initialize
    @pipe = Pipe.new
    @user = Main::Users.new @pipe
  end

  def load
    super() do
      @user.load_from_params attribute_group: :for_update
    end
  end

  def accomplish
    super do
      @user.update
    end
  end
end
