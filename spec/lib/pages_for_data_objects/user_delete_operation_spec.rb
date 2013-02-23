describe "UserDeleteOperation" do
  let(:user) { double }
  let(:pipe) { double }
  subject(:user_delete_operation) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    UserDeleteOperation.new
  end

  def accomplish_prepare_fakes
    user.should_receive(:delete).with(12).and_return true
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
    expect(user_delete_operation.pipe).to eq pipe
  end

  context "deletes user" do
    it "with accomplish" do
      user.should_receive(:set).with(id: 12)
      user_delete_operation.load 12

      accomplish_prepare_fakes
      expect(user_delete_operation.accomplish 12).to be_true
    end

    it "with load_and_accomplish" do
      user.should_receive(:set).with(id: 12)
      accomplish_prepare_fakes
      expect(user_delete_operation.load_and_accomplish id: 12).to be_true
    end
  end
end
