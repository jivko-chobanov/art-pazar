require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')

module Main
  class Fake
  end

  class Qqq
  end

  class OtherFake
  end
end

describe AttributeGroup do
  it "stores attributes" do
    a = AttributeGroup.new :list, [:name, :price], Main::Fake
    expect(a.name).to be :list
    expect(a.attribute_names).to eq [:name, :price]
    expect(a.data_obj_class).to eq Main::Fake

    expect { AttributeGroup.attribute_groups }.to raise_error
    expect(AttributeGroup.get_attributes :list, Main::Fake).to eq [:name, :price]
    expect { AttributeGroup.get_attributes :qqq, Main::Fake }.to raise_error
    expect { AttributeGroup.get_attributes :list, Main::Qqq }.to raise_error

    b = AttributeGroup.new :other, [:id, :category], Main::Fake
    c = AttributeGroup.new :other, [:id], Main::OtherFake
    expect(AttributeGroup.get_attributes :other, Main::Fake).to eq [:id, :category]
    expect(AttributeGroup.get_attributes :other, Main::OtherFake).to eq [:id]
  end
end

