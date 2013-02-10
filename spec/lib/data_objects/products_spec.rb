describe "Main::Products" do
  let(:product_attribute_groups) { double put: nil }
  let(:loaded_data) { double }
  subject(:products) do
    require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')
    Main::Products.new
  end

  before do
    stub_const "DataObjects", Class.new
    stub_const "AttributeGroups", Class.new
    stub_const "LoadedData", Class.new
    stub_const "Pipe", Class.new

    AttributeGroups.should_receive(:new).with(kind_of Hash) { product_attribute_groups }
    DataObjects.send(:define_method, :initialize) { |*args| }
    DataObjects.send(:define_method, :attributes_of) { |*args| "attributes from super" }
  end

  context "when loaded" do
    before do
      products.should_receive(:loaded?).and_return true
    end

    it "gives product type" do
      expect(products.type).to eq :paintings
    end
  end

  context "before loading" do
    before do
      products.should_receive(:loaded?).and_return true
    end

    context "raises error on access to" do
      it "product type" do
        expect(products.type).to eq :paintings
      end
    end
  end
end
