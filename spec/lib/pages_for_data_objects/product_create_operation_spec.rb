describe "ProductCreateOperation" do
  let(:product) { double }
  let(:product_specifications) { double }
  let(:pipe) { double }
  subject(:product_create_page) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    ProductCreateOperation.new
  end

  def load_from_params_prepare_fakes(type)
    product_specifications.should_receive(:type=).with type
    product.should_receive(:load_from_params).with attribute_group: :for_create
    product.should_receive(:type).with(no_args).and_return :paintings
    product_specifications.should_receive(:load_from_params)
      .with attribute_group: :for_create, type: :paintings
  end

  def accomplish_prepare_fakes
    product.should_receive(:create).with(no_args).and_return true
    product.should_receive(:id).with(no_args).and_return 12
    product_specifications.should_receive(:create).with(12).and_return true
  end

  before do
    stub_const "Operation", Class.new
    stub_const "Main", Module.new
    stub_const "Main::Products", Class.new
    stub_const "Main::ProductSpecifications", Class.new
    stub_const "Pipe", Class.new

    Main::Products.stub(:new).and_return product
    Main::ProductSpecifications.stub(:new).and_return product_specifications
    Pipe.stub(:new) { pipe }
    Operation.send(:define_method, :load) { |&block| block.call }
    Operation.send(:define_method, :accomplish) { |&block| block.call }
  end

  it "gets pipe" do
    expect(product_create_page.pipe).to eq pipe
  end

  context "creates product and its specification" do
    it "in two steps" do
      load_from_params_prepare_fakes :paintings
      product_create_page.load :paintings

      accomplish_prepare_fakes
      expect(product_create_page.accomplish).to be_true
    end

    it "in one step" do
      load_from_params_prepare_fakes :paintings
      accomplish_prepare_fakes
      expect(product_create_page.load_and_accomplish product_type: :paintings).to be_true
    end
  end
end
