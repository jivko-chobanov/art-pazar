describe "User" do
  subject(:user) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    User.new
  end

  before :all do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
  end
end
