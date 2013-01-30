require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')

describe ProductsManipulator do
  before :each do
    stub_const "AttributeGroups", Class.new
    attribute_groups = double attributes_of: [:name, :category_id, :price]
    AttributeGroups.stub new: attribute_groups
  end

  it "creates" do
    creation = ProductsManipulator.new :input, :put
    expect(creation.html).to eq("Fill in fields: #{
      Main::Products.attributes_of(:fields_for_put_or_update).join ", "
    }")
  end
end
