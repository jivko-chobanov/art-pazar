unless defined? DataObjects
  class DataObjects
    def initialize(*any_args)
    end
  end
end

require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')

describe Main::ProductSpecifications do
  let(:product_attribute_groups) { double put: nil }
  let(:loaded_data) { double }

  before :each do
    stub_const "AttributeGroups", Class.new
    stub_const "LoadedData", Class.new
    stub_const "Pipe", Class.new
    AttributeGroups.stub(:new).with(kind_of Hash) { product_attribute_groups }
  end

  it "gives attributes of attribute groups" do
    Main::ProductSpecifications.new :paintings
  end

  context "raises error" do
    it "is given wrong product type" do
      expect { Main::ProductSpecifications.new "Qqq" }.to raise_error RuntimeError
    end
  end

  it "interprets its fields differently for every product type" do
    painting_specifications = Main::ProductSpecifications.new :paintings
    expect(painting_specifications.specification_names).to eq [:year, :artist, :paint, :frames]
  end
end
