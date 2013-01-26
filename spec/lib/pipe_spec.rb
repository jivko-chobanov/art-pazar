require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')

describe Pipe do
  it "raises exceptions when undefined command" do
    expect { Pipe.get :data, 1 }.to raise_error
    expect { Pipe.get :data, qqqq: 4 }.to raise_error
    expect { Pipe.get :data, data_obj_name: :product }.to raise_error(
      Pipe::MissingNeedOrInputError
    )
    expect { Pipe.get :data, data_obj_name: :qqq }.to raise_error
    expect { Pipe.get :html, qqq: 4 }.to raise_error(
      Pipe::MissingNeedOrInputError
    )
  end

  it "gets from data object" do
    three_products_for_listing = Pipe.get(:data, {
      data_obj_name: :product,
      attribute_group: :list,
      limit: 3
    })
    expect(three_products_for_listing.count).to be 3
    #     expect(three_products_for_listing.).to be 3
  end
end
