describe "Home" do
  let(:products) { double }
  subject(:home) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    Home.new
  end

  def load_prepare_fakes
    products.stub(:load_from_db)
      .with attribute_group: :list, order: :last, limit: 10
  end

  def html_prepare_fakes
    products.stub(:html).and_return "HTML for list of last 10 products"
  end

  before do
    stub_const "ShowPage", Class.new
    stub_const "Main", Module.new
    stub_const "Main::Products", Class.new

    Main::Products.stub(:new).and_return products
    ShowPage.send(:define_method, :load) { |&block| block.call }
    ShowPage.send(:define_method, :html) { |&block| block.call }
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
    expect(home.pipe_name_of_txt_if_empty_content).to eq :no_products

    products.stub(:html).and_return "No products."
    expect(home.html).to eq "No products."
  end
end
