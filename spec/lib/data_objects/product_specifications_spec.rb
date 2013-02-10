describe "Main::ProductSpecifications" do
  let(:product_attribute_groups) { double put: nil }
  let(:loaded_data) { double }
  subject(:product_specifications) do
    require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')
    Main::ProductSpecifications.new
  end

  before do
    stub_const "DataObjects", Class.new
    stub_const "AttributeGroups", Class.new
    stub_const "LoadedData", Class.new
    stub_const "Pipe", Class.new

    AttributeGroups.stub(:new).with(kind_of Hash) { product_attribute_groups }
    DataObjects.send(:define_method, :initialize) { |*args| }
    DataObjects.send(:define_method, :attributes_of) { |*args| "attributes from super" }
  end

  context "before type is set" do
    context "raises errors on access to" do
      it "attributes" do
        expect { product_specifications.attributes_of :list }.to raise_error RuntimeError
      end

      it "specification_names" do
        expect { product_specifications.specification_names }.to raise_error RuntimeError
      end
    end
  end

  context "on type setting" do
    it "raises error when wrong product type" do
      expect { product_specifications.type = "Qqq" }.to raise_error RuntimeError
    end
  end

  context "after type is set" do
    before do
      product_specifications.type = :paintings
    end

    it "gives attributes of attribute groups" do
      expect(product_specifications.attributes_of :list).to eq "attributes from super"
    end

    it "interprets its fields differently for every product type" do
      expect(product_specifications.specification_names).to eq [:year, :artist, :paint, :frames]
    end
  end
end
