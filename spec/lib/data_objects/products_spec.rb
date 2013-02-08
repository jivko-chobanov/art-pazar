unless defined? DataObjects
  class DataObjects
    def initialize(*any_args)
    end
  end

  require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')

  describe Main::Products do
    let(:product_attribute_groups) { double put: nil }
    let(:loaded_data) { double }
    subject(:products) { Main::Products.new }

    before do
      stub_const "AttributeGroups", Class.new
      stub_const "LoadedData", Class.new
      stub_const "Pipe", Class.new
      AttributeGroups.should_receive(:new).with(kind_of Hash) { product_attribute_groups }
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
end
