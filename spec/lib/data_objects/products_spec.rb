unless defined? DataObjects
  class DataObjects
  end
end

require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')

describe Main::Products do
  let(:product_attribute_groups) { double put: nil }
  let(:loaded_data) { double }

  before :each do
    stub_const "AttributeGroups", Class.new
    stub_const "LoadedData", Class.new
    stub_const "Pipe", Class.new
    DataObjects.stub(:new)
    AttributeGroups.stub(:new).with(kind_of Hash) { product_attribute_groups }
  end

  it "gives attributes of attribute groups" do
    Main::Products.new
  end
end
