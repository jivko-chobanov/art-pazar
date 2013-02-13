describe "ProductCreatePage" do
  let(:product) { double }
  let(:product_specifications) { double }
  let(:pipe) { double }
  subject(:product_create_page) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    ProductCreatePage.new
  end

  def load_from_params_prepare_fakes(type)
    product_specifications.should_receive(:type=).with type
    product.should_receive(:load_from_params).with attribute_group: :for_create
    product.should_receive(:type).with(no_args()).and_return :paintings
    product_specifications.should_receive(:load_from_params)
      .with attribute_group: :for_create, type: :paintings
  end

  def load_from_args_prepare_fakes(type)
    product_specifications.should_receive(:type=).with type
  end

  def html_prepare_fakes
    product.stub(:runtime_table_hash_for_create).and_return "Products" => "data1"
    product_specifications.stub(:runtime_table_hash_for_create).and_return "Specifications" => "data2"
    pipe.stub(:get).with(:html_for_create, data_by_type: {
      "Products" => "data1",
      "Specifications" => "data2"
    }).and_return "HTML for create product page"
  end

  def accomplish_prepare_fakes
    product.should_receive(:create).with(no_args())
    product.should_receive(:id).with(no_args()).and_return 12
    product_specifications.should_receive(:create).with(12)
  end

  before do
    stub_const "UpdateOrCreatePage", Class.new
    stub_const "Main", Module.new
    stub_const "Main::Products", Class.new
    stub_const "Main::ProductSpecifications", Class.new
    stub_const "Pipe", Class.new

    Main::Products.stub(:new).and_return product
    Main::ProductSpecifications.stub(:new).and_return product_specifications
    Pipe.stub(:new) { pipe }
    UpdateOrCreatePage.send(:define_method, :load) { |&block| block.call }
    UpdateOrCreatePage.send(:define_method, :html) { |&block| block.call }
    UpdateOrCreatePage.send(:define_method, :accomplish) { |&block| block.call }
  end

  it "gets pipe" do
    expect(product_create_page.pipe).to eq pipe
  end

  context "loads product and makes create fields html" do
    it "in two steps" do
      load_from_args_prepare_fakes :paintings
      product_create_page.load :from_args, :paintings

      expect(product_create_page.pipe_name_of_txt_if_empty_content).to eq false

      html_prepare_fakes
      expect(product_create_page.html).to eq "HTML for create product page"
    end

    it "in one step" do
      load_from_args_prepare_fakes :paintings
      html_prepare_fakes
      expect(product_create_page.load_and_get_html :paintings).to eq "HTML for create product page"
    end
  end

  context "creates product and its specification" do
    it "in two steps" do
      load_from_params_prepare_fakes :paintings
      product_create_page.load :from_params, :paintings

      accomplish_prepare_fakes
      expect(product_create_page.accomplish).to be_true
    end

    it "in one step" do
      load_from_params_prepare_fakes :paintings
      accomplish_prepare_fakes
      expect(product_create_page.load_and_accomplish :paintings).to be_true
    end
  end
end
