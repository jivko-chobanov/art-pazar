class UpdateOrCreatePage
  def load
    yield if block_given?
  end

  def html
    yield if block_given?
  end
end

require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")

describe ProductCreatePage do
  let(:product) { double }
  subject(:product_create_page) do
    ProductCreatePage.new
  end

  def html_prepare_fakes
    product.stub(:html_for_create).and_return "HTML for create product page"
  end

  before do
    stub_const "Main", Module.new
    stub_const "Main::Products", Class.new

    Main::Products.stub(:new).and_return product
  end

  it "loads product and makes create fields html in two steps" do
    product_create_page.load

    expect(product_create_page.pipe_name_of_txt_if_empty_content).to eq false

    html_prepare_fakes
    expect(product_create_page.html).to eq "HTML for create product page"
  end
end
