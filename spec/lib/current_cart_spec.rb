describe "CurrentCart" do
  let(:pipe) { double }
  let(:cart) { double }
  subject(:visitor) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    CurrentCart.new
  end

  before :all do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
  end

  before do
    stub_const "Pipe", Class.new
    stub_const "Main", Class.new
    stub_const "Main::Carts", Class.new

    Pipe.stub(:new) { pipe }
    Main::Carts.stub(:new) { cart }
  end

  xit "can be created only with the first product" do
  end

  context "after creation" do
    xit "new product can be added" do
    end

    xit "count of products can be raised" do
    end
  end

  xit "is deleted when the last product is deleted" do
  end
end
