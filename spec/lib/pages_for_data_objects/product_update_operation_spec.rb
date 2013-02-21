describe "ProductUpdateOperation" do
  let(:product) { double }
  let(:product_specifications) { double }
  let(:pipe) { double }
  subject(:product_update_operation) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    ProductUpdateOperation.new
  end

  def load_from_params_prepare_fakes
    product.stub(:load_from_params).with attribute_group: :for_update
    product.should_receive(:type).and_return :paintings
    product_specifications.stub(:load_from_params).with attribute_group: :for_update, type: :paintings
  end

  def accomplish_prepare_fakes
    product.should_receive(:update).with(no_args()).and_return true
    product_specifications.should_receive(:update).with(no_args()).and_return true
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
    expect(product_update_operation.pipe).to eq pipe
  end

  context "updates product and its specification" do
    it "in two steps" do
      load_from_params_prepare_fakes
      product_update_operation.load

      accomplish_prepare_fakes
      expect(product_update_operation.accomplish).to be_true
    end
  end
end
