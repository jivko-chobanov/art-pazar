require(__FILE__.split('art_pazar/').first << '/art_pazar/lib/lib_loader.rb')

describe "In integration" do
  let(:cart_controller) { CartController.new }

  context "when creating" do
    it "has one product" do
      expect(cart_controller.products_count).to eq 1
    end

    xit "raises error if no product in params" do
      expect { CartController.new }.to raise_error RuntimeError
    end
  end

  it "new product can be added" do
    cart_controller.add_product_from_params
    expect(cart_controller.products_count).to eq 2

    cart_controller.add_product_from_params
    expect(cart_controller.products_count).to eq 3
  end

  it "quantity of a product can be changed" do
    expect(cart_controller.update_quantity id: 24, quantity: 2).to be_true
    expect { cart_controller.update_quantity id: 13, quantity: 2 }.to raise_error RuntimeError
  end

  it "products can be removed from cart" do
    cart_controller.remove id: 24
    expect(cart_controller.products_count).to eq 0
  end

  xit "is deleted when the last product is deleted" do
  end
end
