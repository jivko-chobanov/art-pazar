describe "ProductsInCart" do
  let(:product_attribute_groups) { double put: nil }
  let(:runtime_table) { double }
  let(:row) { double }
  subject(:product_in_cart) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    Main::ProductsInCart.new
  end

  before do
    stub_const "DataObjects", Class.new
    stub_const "AttributeGroups", Class.new
    stub_const "Pipe", Class.new
    stub_const "RuntimeTable", Class.new

    AttributeGroups.should_receive(:new).with(kind_of Hash) { product_attribute_groups }
    DataObjects.send(:define_method, :initialize) { |*args| }
    DataObjects.send(:define_method, :attributes_of) { |*args| "attributes from super" }
    Pipe.stub(:new) { pipe }
    RuntimeTable.stub(:new) { runtime_table }
    runtime_table.stub(:row).and_return row
  end

  context "general information:" do
    it "gives abbreviation" do
      expect(product_in_cart.class_abbreviation).to be_kind_of String
      expect(product_in_cart.class_abbreviation).not_to be_empty
    end
  end
end
