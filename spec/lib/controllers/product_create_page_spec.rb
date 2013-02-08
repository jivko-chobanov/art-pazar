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
  let(:product_specifications) { double }
  let(:pipe) { double }
  subject(:product_create_page) do
    ProductCreatePage.new
  end

  def load_prepare_fakes(type)
    product_specifications.should_receive(:type=).with type
  end

  def html_prepare_fakes
    product.stub(:loaded_data_hash_for_create).and_return "Products" => "data1"
    product_specifications.stub(:loaded_data_hash_for_create).and_return "Specifications" => "data2"
    pipe.stub(:get).with(:html_for_create, data_by_type: {
      "Products" => "data1",
      "Specifications" => "data2"
    }).and_return "HTML for create product page"
  end

  before do
    stub_const "Main", Module.new
    stub_const "Main::Products", Class.new
    stub_const "Main::ProductSpecifications", Class.new
    stub_const "Pipe", Class.new

    Main::Products.stub(:new).and_return product
    Main::ProductSpecifications.stub(:new).and_return product_specifications
    Pipe.stub(:new) { pipe }
  end

  context "loads product and makes create fields html" do
    it "in two steps" do
      load_prepare_fakes :paintings
      product_create_page.load :paintings

      expect(product_create_page.pipe_name_of_txt_if_empty_content).to eq false

      html_prepare_fakes
      expect(product_create_page.html).to eq "HTML for create product page"
    end

    it "in one step" do
      load_prepare_fakes :paintings
      html_prepare_fakes
      expect(product_create_page.load_and_get_html :paintings).to eq "HTML for create product page"
    end
  end
end
