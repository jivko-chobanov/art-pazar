require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')

describe AttributeGroups do
  before :each do
    stub_const "Main", Module.new
    stub_const "Main::Fake", Class.new
    stub_const "Main::Qqq", Class.new
    stub_const "Main::OtherFake", Class.new
  end

  it "stores and gets attributes" do
    attribute_groups = AttributeGroups.new list: [:name, :price]
    expect { attribute_groups.put :list, [:other, :price] }.to raise_error

    expect(attribute_groups.attributes_of :list).to eq [:name, :price]
    expect { attribute_groups.attributes_of :qqq }.to raise_error

    attribute_groups.put :other, [:id, :category]
    expect(attribute_groups.attributes_of :other).to eq [:id, :category]
    expect(attribute_groups.attributes_of :list).to eq [:name, :price]
  end

  it "gets individual group and can read its properties" do
    attribute_groups = AttributeGroups.new
    attribute_groups.put :list, [:name, :price]
    attribute_group = attribute_groups.get :list

    expect { attribute_groups.get :qqq }.to raise_error

    expect(attribute_group.name).to be :list
    expect(attribute_group.attributes).to eq [:name, :price]
  end
end
