describe "CartCreateOperation" do
  let(:cart) { double }
  let(:pipe) { double }
  subject(:cart_create_page) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    CartCreateOperation.new
  end

  def load_from_params_prepare_fakes
    cart.should_receive(:load_from_params).with attribute_group: :for_create
  end

  def accomplish_prepare_fakes
    cart.should_receive(:create).with(no_args).and_return true
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
    expect(cart_create_page.pipe).to eq pipe
  end

  context "creates cart" do
    it "in two steps" do
      load_from_params_prepare_fakes
      cart_create_page.load

      accomplish_prepare_fakes
      expect(cart_create_page.accomplish).to be_true
    end

    it "in one step" do
      load_from_params_prepare_fakes
      accomplish_prepare_fakes
      expect(cart_create_page.load_and_accomplish).to be_true
    end
  end
end
