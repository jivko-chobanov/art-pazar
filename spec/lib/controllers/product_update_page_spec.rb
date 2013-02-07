class UpdateOrCreatePage
  def load
    yield if block_given?
  end

  def html
    yield if block_given?
  end
end

require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")

describe ProductUpdatePage do
  let(:product) { double }
  subject(:product_update_page) do
    ProductUpdatePage.new
  end

  def load_prepare_fakes
    product.stub(:load)
      .with attribute_group: :for_update, limit: 1 
  end

  def html_prepare_fakes
    product.stub(:html_for_update).and_return "HTML for update product page"
  end

  before do
    stub_const "Main", Module.new
    stub_const "Main::Products", Class.new

    Main::Products.stub(:new).and_return product
  end

  it "loads product and makes update fields html in two steps" do
    load_prepare_fakes
    product_update_page.load

    html_prepare_fakes
    expect(product_update_page.html).to eq "HTML for update product page"
  end

  it "displays msg if no product to load" do
    load_prepare_fakes
    product_update_page.load

    product.stub(:loaded_empty_result?).with(no_args).and_return true
    expect(product_update_page.pipe_name_of_txt_if_empty_content).to eq :no_product

    product_update_page.stub(:html).and_return "No product."
    expect(product_update_page.html).to eq "No product."
  end
end
