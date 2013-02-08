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
  let(:product_specifications) { double }
  let(:pipe) { double }
  subject(:product_update_page) do
    ProductUpdatePage.new
  end

  def load_prepare_fakes
    product.stub(:load)
      .with attribute_group: :for_update, limit: 1 
    product_specifications.stub(:load)
      .with attribute_group: :for_update, limit: 1 
    product.should_receive(:type).and_return :paintings
    product_specifications.should_receive(:type=).with :paintings
  end

  def html_prepare_fakes
    product.stub(:loaded_data_hash_for_update).and_return "Products" => "data1"
    product_specifications.stub(:loaded_data_hash_for_update).and_return "Specifications" => "data2"
    pipe.stub(:get).with(:html_for_update, data_by_type: {
      "Products" => "data1",
      "Specifications" => "data2"
    }).and_return "HTML for update product page"
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

  context "loads product and makes update fields html" do
    it "in two steps" do
      load_prepare_fakes
      product_update_page.load

      product.stub(:loaded_empty_result?).with(no_args).and_return false
      expect(product_update_page.pipe_name_of_txt_if_empty_content).to eq false

      html_prepare_fakes
      expect(product_update_page.html).to eq "HTML for update product page"
    end
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
