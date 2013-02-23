describe "Main::ProductSpecifications" do
  let(:product_attribute_groups) { double put: nil }
  let(:runtime_table) { double }
  let(:row) { double }
  subject(:product_specifications) do
    require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')
    Main::ProductSpecifications.new
  end

  before do
    stub_const "DataObjects", Class.new
    stub_const "AttributeGroups", Class.new
    stub_const "RuntimeTable", Class.new
    stub_const "Pipe", Class.new

    AttributeGroups.stub(:new).with(kind_of Hash) { product_attribute_groups }
    DataObjects.send(:define_method, :initialize) { |*args| }
    DataObjects.send(:define_method, :load_from_params) { |*args| }
    DataObjects.send(:define_method, :load_from_db) { |*args| }
    DataObjects.send(:define_method, :attributes_of) { |*args| "attributes from super" }
    DataObjects.send(:define_method, :create) do |*args|
      "true from super with args: #{args.join ", "}"
    end
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

    context "can set type on doing something else" do
      it "loads from params" do
        product_specifications.load_from_params any: :any, type: :paintings
        expect(product_specifications.type).to eq :paintings
      end

      it "loads from db" do
        product_specifications.load_from_db any: :any, type: :paintings
        expect(product_specifications.type).to eq :paintings
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
      expect(product_specifications.specification_names).to eq [:id, :year, :artist, :paint, :frames]
    end

    it "gives type" do
      expect(product_specifications.type).to eq :paintings
    end
  end

  context "when creating" do
    it "creates the normal way with super" do
      expect(product_specifications.create).to eq "true from super with args: "
      expect(product_specifications.create :attrs).to eq "true from super with args: attrs"
    end

    it "if product_id then first adds it to loaded data" do
      product_specifications.instance_variable_set :@runtime_table, runtime_table
      runtime_table.should_receive(:row).with(no_args).and_return row
      row.should_receive(:<<).with product_id: 12
      expect(product_specifications.create 12).to eq "true from super with args: "
    end
  end

  context "general information:" do
    it "gives abbreviation" do
      expect(product_specifications.class_abbreviation).to be_kind_of String
      expect(product_specifications.class_abbreviation).not_to be_empty
    end
  end
end
