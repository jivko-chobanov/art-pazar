describe "CartUpdateOperation" do
  let(:cart) { double }
  let(:pipe) { double }
  subject(:cart_update_operation) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    CartUpdateOperation.new
  end

  def load_from_params_prepare_fakes
    cart.should_receive(:load_from_params).with attribute_group: :for_update
  end

  def accomplish_prepare_fakes
    cart.should_receive(:update).with(no_args).and_return true
  end

  before do
    stub_const "Operation", Class.new
    stub_const "Main", Module.new
    stub_const "Main::Carts", Class.new
    stub_const "Pipe", Class.new

    Main::Carts.stub(:new).and_return cart
    Pipe.stub(:new) { pipe }
    Operation.send(:define_method, :load) { |&block| block.call }
    Operation.send(:define_method, :accomplish) { |&block| block.call }
  end

  it "gets pipe" do
    expect(cart_update_operation.pipe).to eq pipe
  end

  context "updates cart" do
    it "in two steps" do
      load_from_params_prepare_fakes
      cart_update_operation.load

      accomplish_prepare_fakes
      expect(cart_update_operation.accomplish).to be_true
    end
  end
end
