require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')

describe "Product creation" do
  let(:product) { double }

  before do
    stub_const "Main", Module.new
    stub_const "Main::Products", Class.new
  end

  it "gets input fields html" do
    product_creation = ProductsManipulator.new

    Main::Products.should_receive(:new).and_return product
    product.should_receive(:input_fields_html).and_return "input fields HTML"

    expect(product_creation.input_fields_html).to eq "input fields HTML"
  end
end
