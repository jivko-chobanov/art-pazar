class User
  attr_reader :type

  def initialize
    @type = :visitor
    @pipe = Pipe.new
  end

  def authenticate(username, password)
    authentication_hash = @pipe.get :authentication_hash, username: username, password: password
    @type = authentication_hash[:type]
    not @type == :visitor
  end
end
