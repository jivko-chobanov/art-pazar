describe "ProductListPage" do
  let(:products) { double }
  subject(:product_list_page) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    ProductListPage.new
  end

  def load_prepare_fakes
    products.should_receive(:load_from_db)
      .with attribute_group: :list, order: :last, limit: 10
  end

  def html_prepare_fakes
    products.should_receive(:html).and_return "HTML for list of last 10 products"
  end

  before do
    stub_const "Page", Class.new
    stub_const "Main", Module.new
    stub_const "Main::Products", Class.new

    Main::Products.stub(:new).and_return products
    Page.send(:define_method, :load) { |&block| block.call }
    Page.send(:define_method, :html) { |&block| block.call }
  end

  it "loads products and makes html in two steps" do
    load_prepare_fakes
    product_list_page.load

    html_prepare_fakes
    expect(product_list_page.html).to eq "HTML for list of last 10 products"
  end

  it "displays msg if no products to load" do
    load_prepare_fakes
    product_list_page.load

    products.should_receive(:loaded_empty_result?).with(no_args).and_return true
    expect(product_list_page.pipe_name_of_txt_if_empty_content).to eq :no_products

    products.should_receive(:html).and_return "No products."
    expect(product_list_page.html).to eq "No products."
  end
end
