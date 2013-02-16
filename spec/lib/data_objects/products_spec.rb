describe "Main::Products" do
  let(:product_attribute_groups) { double put: nil }
  let(:runtime_table) { double }
  let(:row) { double }
  subject(:products) do
    require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')
    Main::Products.new
  end

  before do
    stub_const "DataObjects", Class.new
    stub_const "AttributeGroups", Class.new
    stub_const "RuntimeTable", Class.new
    stub_const "Pipe", Class.new

    AttributeGroups.should_receive(:new).with(kind_of Hash) { product_attribute_groups }
    DataObjects.send(:define_method, :initialize) { |*args| }
    DataObjects.send(:define_method, :attributes_of) { |*args| "attributes from super" }
  end

  context "when loaded" do
    before do
      products.should_receive(:loaded?).at_least(:once).and_return true
    end

    it "gives product type" do
      expect(products.type).to eq :paintings
    end

    context "when ok" do
      it "gives id" do
        products.instance_variable_set :@runtime_table, runtime_table

        runtime_table.should_receive(:row).at_least(:once).and_return row
        row.should_receive(:respond_to?).at_least(:once).with(:id).and_return true
        row.should_receive(:id).at_least(:once).with(no_args()).and_return 12
        expect(products.id).to eq 12
      end
    end

    context "when wrong" do
      it "raises error on #id" do
        products.instance_variable_set :@runtime_table, runtime_table

        runtime_table.should_receive(:row).at_least(:once).and_return row
        row.should_receive(:respond_to?).at_least(:once).with(:id).and_return false
        expect { products.id }.to raise_error RuntimeError
      end
    end
  end

  context "before loading" do
    before do
      products.should_receive(:loaded?).at_least(:once).and_return false
    end

    context "raises error on access to" do
      it "product type" do
        expect { products.type }.to raise_error RuntimeError
      end

      it "id" do
        expect { products.id }.to raise_error RuntimeError
      end
    end
  end

  context "general information:" do
    it "gives abbreviation" do
      expect(products.class_abbreviation).to be_kind_of String
      expect(products.class_abbreviation).not_to be_empty
    end
  end
end
