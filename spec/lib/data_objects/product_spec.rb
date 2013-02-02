require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')

describe Main::Products do
  let(:product_attribute_groups) { double put: nil }
  let(:loaded_data) { double }

  def load_with_args(products, args)
    Pipe.should_receive(:get)
      .with(:loaded_data_obj, args.merge(data_obj_class: Main::Products))
      .and_return "content got by pipe"
    loaded_data.should_receive(:put).with :products, "content got by pipe"
    products.load args
  end

  before :each do
    stub_const "AttributeGroups", Class.new
    stub_const "LoadedData", Class.new
    stub_const "Pipe", Class.new

    AttributeGroups.stub(:new) { product_attribute_groups }
    LoadedData.stub(:new) { loaded_data }
  end

  it "gives attributes of attribute groups" do
    product_attribute_groups.stub(:attributes_of).with(:list).and_return [:name, :price]
    expect(Main::Products.attributes_of :list).not_to be_empty

    product_attribute_groups.should_receive(:attributes_of).with(:qqq)
    expect(Main::Products.attributes_of :qqq).to raise_error
  end

  it "gives information about data" do
    empty_products = Main::Products.new
    expect { empty_products.loaded_empty_result? }.to raise_error RuntimeError
    expect(empty_products.initialized_only?).to be_true

    load_with_args empty_products, attribute_group: :list, limit: 0

    loaded_data.stub(:empty?).and_return true
    expect(empty_products.initialized_only?).to be_false
    expect(empty_products.loaded_empty_result?).to be_true

    not_empty_products = Main::Products.new
    load_with_args not_empty_products, attribute_group: :list, limit: 1
    loaded_data.stub(:empty?).and_return false
    expect(not_empty_products.loaded_empty_result?).to be_false
  end

  it "creates" do
    product_attribute_groups.stub(:attributes_of).with(:fields_for_put_or_update)
      .and_return [:name, :category_id, :price]

    expect(Main::Products.new.input_fields_html).to eq(
      "Fill in fields: name, category_id, price"
    )
  end

  it "updates" do
  end

  it "produces visualization" do
    product_attribute_groups.stub(:attributes_of).with(:list).and_return [:name, :price]
    
    Pipe.stub(:get) { "content got by pipe" }

    products = Main::Products.new
    expect { products.html }.to raise_error
    loaded_data.should_receive(:put).with :products, "content got by pipe"
    products.load attribute_group: :list, limit: 5
    
    expect(products.html).to eq "content got by pipe"
  end
end
