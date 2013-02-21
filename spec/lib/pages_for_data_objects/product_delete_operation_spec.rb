describe "ProductDeleteOperation" do
  let(:product) { double }
  let(:product_specifications) { double }
  let(:pipe) { double }
  subject(:product_delete_page) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    ProductDeleteOperation.new
  end

  def accomplish_prepare_fakes
    product.should_receive(:delete).with(12)
    product_specifications.should_receive(:delete).with(product_id: 12)
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
    Operation.send(:define_method, :load) { |&block| block.call if block_given? }
    Operation.send(:define_method, :accomplish) { |&block| block.call }
  end

  it "gets pipe" do
    expect(product_delete_page.pipe).to eq pipe
  end

  context "deletes product and its specification" do
    it "with accomplish" do
      accomplish_prepare_fakes
      expect(product_delete_page.accomplish 12).to be_true
    end

    it "with load_and_accomplish" do
      accomplish_prepare_fakes
      expect(product_delete_page.load_and_accomplish id: 12).to be_true
    end
  end
end
