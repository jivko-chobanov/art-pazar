module ShowPage
end

require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")

describe Home do
  let(:products) { double }
  subject(:home) do
    Home.send(:define_method, :initialize_show_page) {}
    Home.new
  end

  def load_prepare_fakes
    home.stub(:load_show_page).and_yield
    products.stub(:load)
      .with attribute_group: :list, order: :last, limit: 10
  end

  def html_prepare_fakes
    home.stub(:html_of_show_page).and_return "HTML for list of last 10 products"
    products.stub(:loaded_empty_result?).and_return false
  end

  before do
    stub_const "Main", Module.new
    stub_const "Main::Products", Class.new

    Main::Products.stub(:new).and_return products
  end

  it "loads products and makes html in two steps" do
    load_prepare_fakes
    home.load

    html_prepare_fakes
    expect(home.html).to eq "HTML for list of last 10 products"
  end

  it "displays msg if no products to load" do
    load_prepare_fakes
    home.load

    products.stub(:loaded_empty_result?).with(no_args).and_return true
    home.stub(:html_of_show_page).with(:no_products).and_return "No products."
    expect(home.html).to eq "No products."
  end
end
