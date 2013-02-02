require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")

describe Home do
  let(:products) { double }
  let(:home) { Home.new }

  def load_home
    products.should_receive(:load)
      .with(attribute_group: :list, order: :last, limit: 10) 
    home.load
  end

  before do
    stub_const "Main", Module.new
    stub_const "Main::Products", Class.new
    stub_const "Pipe", Class.new

    Main::Products.should_receive(:new).and_return products
  end

  it "displays products" do
    load_home

    products.should_receive(:initialized_only?).and_return false
    products.should_receive(:loaded_empty_result?).and_return false
    products.should_receive(:html).and_return "HTML for list of last 10 products"
    expect(home.html).to eq "HTML for list of last 10 products"
  end

  it "raises errors" do
    products.should_receive(:initialized_only?).and_return true
    expect { home.html }.to raise_error RuntimeError

    expect(home.tried_to_load).to be_false
    load_home
    expect(home.tried_to_load).to be_true
    expect { home.load }.to raise_error RuntimeError
  end

  it "displays msg if no products to load" do
    load_home

    products.should_receive(:initialized_only?).and_return false
    home.instance_variable_get(:@products).stub(:loaded_empty_result?) { true }
    Pipe.should_receive(:get).with(:txt, txt: :no_products_for_home_page).and_return "No products."
    expect(home.html).to eq "No products."
  end
end
