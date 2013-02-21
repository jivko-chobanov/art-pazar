describe "Carts" do
  let(:product_attribute_groups) { double put: nil }
  let(:runtime_table) { double }
  let(:row) { double }
  subject(:cart) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    Main::Carts.new
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
      expect(cart.class_abbreviation).to be_kind_of String
      expect(cart.class_abbreviation).not_to be_empty
    end
  end
end
