describe "UserUpdateOperation" do
  let(:user) { double }
  let(:pipe) { double }
  subject(:user_update_operation) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    UserUpdateOperation.new
  end

  def load_from_params_prepare_fakes
    user.stub(:load_from_params).with attribute_group: :for_update
  end

  def accomplish_prepare_fakes
    user.should_receive(:update).with(no_args()).and_return true
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
    expect(user_update_operation.pipe).to eq pipe
  end

  context "updates user" do
    it "in two steps" do
      load_from_params_prepare_fakes
      user_update_operation.load

      accomplish_prepare_fakes
      expect(user_update_operation.accomplish).to be_true
    end
  end
end
