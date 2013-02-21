describe "UserDeleteOperation" do
  let(:user) { double }
  let(:pipe) { double }
  subject(:user_delete_page) do
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
    Operation.send(:define_method, :load) { |&block| block.call if block_given? }
    Operation.send(:define_method, :accomplish) { |&block| block.call }
  end

  it "gets pipe" do
    expect(user_delete_page.pipe).to eq pipe
  end

  context "deletes user" do
    it "with accomplish" do
      accomplish_prepare_fakes
      expect(user_delete_page.accomplish 12).to be_true
    end

    it "with load_and_accomplish" do
      accomplish_prepare_fakes
      expect(user_delete_page.load_and_accomplish id: 12).to be_true
    end
  end
end
