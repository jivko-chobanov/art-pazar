describe "Users" do
  let(:product_attribute_groups) { double put: nil }
  let(:pipe) { double }
  let(:runtime_table) { double }
  let(:row) { double }
  subject(:user) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    Users.new
  end

  before :all do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
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
end
