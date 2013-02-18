describe "ProductBlankForCreatePage" do
  let(:product) { double }
  let(:product_specifications) { double }
  let(:pipe) { double }
  subject(:product_blank_for_create_page) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    ProductBlankForCreatePage.new
  end

  def load_from_args_prepare_fakes(type)
    product_specifications.should_receive(:type=).with type
  end

  def html_prepare_fakes
    product.stub(:attributes_of).and_return ["attribute names 1"]
    product_specifications.stub(:attributes_of).and_return ["attribute names 2"]
    product.stub(:data_obj_name).and_return "Products"
    product_specifications.stub(:data_obj_name).and_return "ProductSpecifications"
    pipe.stub(:get).with(:html_for_create, data_by_type: {
      "Products" => ["attribute names 1"],
      "ProductSpecifications" => ["attribute names 2"]
    }).and_return "HTML for create product page"
  end

  before do
    stub_const "Page", Class.new
    stub_const "Main", Module.new
    stub_const "Main::Products", Class.new
    stub_const "Main::ProductSpecifications", Class.new
    stub_const "Pipe", Class.new

    Main::Products.stub(:new).and_return product
    Main::ProductSpecifications.stub(:new).and_return product_specifications
    Pipe.stub(:new) { pipe }
    Page.send(:define_method, :load) { |&block| block.call }
    Page.send(:define_method, :html) { |&block| block.call }
  end

  it "gets pipe" do
    expect(product_blank_for_create_page.pipe).to eq pipe
  end

  context "loads product and makes create fields html" do
    it "in two steps" do
      load_from_args_prepare_fakes :paintings
      product_blank_for_create_page.load :paintings

      expect(product_blank_for_create_page.pipe_name_of_txt_if_empty_content).to eq false

      html_prepare_fakes
      expect(product_blank_for_create_page.html).to eq "HTML for create product page"
    end

    it "in one step" do
      load_from_args_prepare_fakes :paintings
      html_prepare_fakes
      expect(product_blank_for_create_page.load_and_get_html :paintings).to eq "HTML for create product page"
    end
  end
end
