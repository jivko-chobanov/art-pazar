describe "CartController" do
  let(:pipe) { double }
  let(:cart_data_object) { double }
  let(:products_in_cart) { double }
  subject(:cart_controller) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")

    cart_data_object.should_receive(:load_and_create).with(no_args).and_return true
    products_in_cart.should_receive(:load_and_create).with(no_args).and_return true
    CartController.new 
  end

  before :all do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
  end

  before do
    stub_const "Pipe", Class.new
    stub_const "Main", Class.new
    stub_const "Main::Carts", Class.new
    stub_const "Main::ProductsInCart", Class.new

    Pipe.stub(:new) { pipe }
    Main::Carts.stub(:new) { cart_data_object }
    Main::ProductsInCart.stub(:new) { products_in_cart }
  end

  context "when creating" do
    it "has one product" do
      products_in_cart.should_receive(:size).with(no_args).and_return 1
      expect(cart_controller.products_count).to eq 1
    end

    it "raises error if no product in params" do
      products_in_cart.should_receive(:load_and_create).with(no_args).and_return false
      expect { CartController.new }.to raise_error RuntimeError
    end
  end

  it "new product can be added" do
    products_in_cart.should_receive(:load_and_create).with(no_args).and_return true
    cart_controller.add_product_from_params

    products_in_cart.should_receive(:load_and_create).with(no_args).and_return false
    expect { cart_controller.add_product_from_params }.to raise_error RuntimeError
  end

  it "quantity of a product can be changed" do
    products_in_cart.should_receive(:update).with(id: 13, quantity: 2).and_return true
    products_in_cart.should_receive(:each).and_yield id: 13, quantity: 8
    expect(cart_controller.update_quantity id: 13, quantity: 2).to be_true

    expect { cart_controller.update_quantity quantity: 2 }.to raise_error RuntimeError
    expect { cart_controller.update_quantity id: 13 }.to raise_error RuntimeError

    products_in_cart.should_receive(:each).and_yield quantity: 8
    expect { cart_controller.update_quantity id: 13, quantity: 2 }.to raise_error RuntimeError
  end

  it "products can be removed from cart" do
    products_in_cart.should_receive(:size).with(no_args).and_return 2
    products_in_cart.should_receive(:delete).with(id: 24).and_return true
    expect(cart_controller.remove id: 24).to be_true
  end

  it "is deleted when the last product is deleted" do
    products_in_cart.should_receive(:size).with(no_args).and_return 1
    products_in_cart.should_receive(:delete).with(id: 24).and_return true
    cart_data_object.should_receive(:delete).with(no_args).and_return true
    expect(cart_controller.remove id: 24).to be_true
  end

  it "fails when the cart fails to be deleted" do
    products_in_cart.should_receive(:size).with(no_args).and_return 1
    products_in_cart.should_receive(:delete).with(id: 24).and_return true
    cart_data_object.should_receive(:delete).with(no_args).and_return false
    expect(cart_controller.remove id: 24).to be_false
  end

  it "fails when the last product fails to be deleted" do
    products_in_cart.should_receive(:delete).with(id: 24).and_return false
    expect(cart_controller.remove id: 24).to be_false
  end
end
