module ShowPage
end

require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")

describe ProductShow do
  let(:product) { double }
  subject(:product_show) do
    ProductShow.send(:define_method, :initialize_show_page) {}
    ProductShow.new
  end

  def load_prepare_fakes
    product_show.stub(:load_show_page).and_yield
    product.stub(:load)
      .with attribute_group: :for_visitor, limit: 1 
  end

  def html_prepare_fakes
    product_show.stub(:html_of_show_page).and_return "HTML for product page"
    product.stub(:loaded_empty_result?).and_return false
  end

  before do
    stub_const "Main", Module.new
    stub_const "Main::Products", Class.new

    Main::Products.stub(:new).and_return product
  end

  it "loads product and makes html in two steps" do
    load_prepare_fakes
    product_show.load

    html_prepare_fakes
    expect(product_show.html).to eq "HTML for product page"
  end

  it "displays msg if no product to load" do
    load_prepare_fakes
    product_show.load

    product.stub(:loaded_empty_result?).with(no_args).and_return true
    product_show.stub(:html_of_show_page).with(:no_product).and_return "No product."
    expect(product_show.html).to eq "No product."
  end
end
