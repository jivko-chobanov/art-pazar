describe "CartDeleteOperation" do
  let(:cart) { double }
  let(:pipe) { double }
  subject(:cart_delete_page) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    CartDeleteOperation.new
  end

  def accomplish_prepare_fakes
    cart.should_receive(:delete).with(12).and_return true
  end

  before do
    stub_const "Operation", Class.new
    stub_const "Main", Module.new
    stub_const "Main::Carts", Class.new
    stub_const "Pipe", Class.new

    Main::Carts.stub(:new).and_return cart
    Pipe.stub(:new) { pipe }
    Operation.send(:define_method, :load) { |&block| block.call if block_given? }
    Operation.send(:define_method, :accomplish) { |&block| block.call }
  end

  it "gets pipe" do
    expect(cart_delete_page.pipe).to eq pipe
  end

  context "deletes cart" do
    it "with accomplish" do
      accomplish_prepare_fakes
      expect(cart_delete_page.accomplish 12).to be_true
    end

    it "with load_and_accomplish" do
      accomplish_prepare_fakes
      expect(cart_delete_page.load_and_accomplish id: 12).to be_true
    end
  end
end
