require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')

describe Pipe do
  before :each do
    stub_const "Main", Module.new

    stub_const "Main::Products", Class.new
    Main::Products.stub(:attributes_of) { [:name, :price] }

    stub_const "Main::Qqq", Class.new
    stub_const "Support", Class.new
  end

  it "raises exceptions when undefined command" do
    expect { Pipe.get :loaded_data_obj, 1 }.to raise_error
    expect { Pipe.get :loaded_data_obj, qqqq: 4 }.to raise_error
    expect { Pipe.get :loaded_data_obj, data_obj_class: Main::Products }.to raise_error(
      Pipe::MissingNeedOrInputError
    )
    expect { Pipe.get :loaded_data_obj, data_obj_class: Main::Qqq }.to raise_error
    expect { Pipe.get :html, qqq: 4 }.to raise_error(
      Pipe::MissingNeedOrInputError
    )
  end

  it "gets from data object" do
    three_products_for_listing = Pipe.get(:loaded_data_obj, {
      data_obj_class: Main::Products,
      attribute_group: :list,
      limit: 3
    })
    expect(three_products_for_listing.count).to be 3
    expect(three_products_for_listing.first.keys).to eq Main::Products.attributes_of(:list)
  end

  unless defined? Rails
    it "generates txt messages" do
      expect(Pipe.get :txt, txt: :no_products_for_home_page).not_to be_empty
    end

    it "generates fake html" do
      three_products_for_listing = Pipe.get(:loaded_data_obj, {
        data_obj_class: Main::Products,
        attribute_group: :list,
        limit: 3
      })

      Support.should_receive(:as_table_string) { "table string" }
      loaded_data = LoadedData.new
      loaded_data.put(:products, three_products_for_listing)
      Support.stub empty?: false
      html = Pipe.get :html, loaded_data_obj: loaded_data

      expected_html =
        "HTML for products\n\n" <<
        "products:\n"

      expect(html.lines.first).to eq expected_html.lines.first
      expect(html.lines.to_a[1]).to eq expected_html.lines.to_a[1]
      expect(html.lines.to_a[2]).to eq expected_html.lines.to_a[2]
    end
  end
end
