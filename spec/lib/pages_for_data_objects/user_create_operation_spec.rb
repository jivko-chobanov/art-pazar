describe "UserCreateOperation" do
  let(:user) { double }
  let(:pipe) { double }
  subject(:user_create_page) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    UserCreateOperation.new
  end

  def load_from_params_prepare_fakes
    user.should_receive(:load_from_params).with attribute_group: :for_create
  end

  def accomplish_prepare_fakes
    user.should_receive(:create).with(no_args()).and_return true
  end

  before do
    stub_const "Operation", Class.new
    stub_const "Main", Module.new
    stub_const "Main::Users", Class.new
    stub_const "Pipe", Class.new

    Main::Users.stub(:new).and_return user
    Pipe.stub(:new) { pipe }
    Operation.send(:define_method, :load) { |&block| block.call }
    Operation.send(:define_method, :accomplish) { |&block| block.call }
  end

  it "gets pipe" do
    expect(user_create_page.pipe).to eq pipe
  end

  context "creates user" do
    it "in two steps" do
      load_from_params_prepare_fakes
      user_create_page.load

      accomplish_prepare_fakes
      expect(user_create_page.accomplish).to be_true
    end

    it "in one step" do
      load_from_params_prepare_fakes
      accomplish_prepare_fakes
      expect(user_create_page.load_and_accomplish).to be_true
    end
  end
end
