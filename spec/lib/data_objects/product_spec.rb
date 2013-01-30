require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')

describe Main::Products do
  before :each do
    stub_const "AttributeGroups", Class.new
  end

  it "gives general information" do
    product_attribute_groups = double put: nil
    AttributeGroups.stub(:new) { product_attribute_groups }
    product_attribute_groups.stub(:attributes_of).with(:list).and_return [:name, :price]
    product_attribute_groups.should_receive(:attributes_of).with(:qqq)

    expect(Main::Products.attributes_of :list).not_to be_empty
    expect(Main::Products.attributes_of :qqq).to raise_error
  end

  it "gives information about data" do
    product_attribute_groups = double put: nil
    AttributeGroups.stub(:new) { product_attribute_groups }
    product_attribute_groups.stub(:attributes_of).with(:list).and_return [:name, :price]

    empty_products = Main::Products.new
    expect { empty_products.loaded_empty_result? }.to raise_error
    expect(empty_products.initialized_only?).to be_true

    empty_products.get attribute_group: :list, limit: 0
    expect(empty_products.loaded_empty_result?).to be_true
    expect(empty_products.initialized_only?).to be_false

    not_empty_products = Main::Products.new
    not_empty_products.get attribute_group: :list, limit: 1
    expect(not_empty_products.loaded_empty_result?).to be_false
  end

  it "creates new" do
  end

  it "updates" do
  end

  it "produces visualization" do
    product_attribute_groups = double put: nil
    AttributeGroups.stub(:new) { product_attribute_groups }
    product_attribute_groups.stub(:attributes_of).with(:list).and_return [:name, :price]

    products = Main::Products.new
    expect { products.html }.to raise_error
    products.get attribute_group: :list, limit: 5
    
    expect(products.html).not_to be_nil
    expect(products.html).not_to be_empty
  end
end
