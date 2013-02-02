require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')

describe Pipe do
  let(:loaded_data) { double }

  before :each do
    stub_const "Main", Module.new

    stub_const "Main::Products", Class.new
    Main::Products.stub(:attributes_of) { [:name, :price] }

    stub_const "Main::Qqq", Class.new
    stub_const "Support", Class.new
  end

  context "when undefined command" do
    it "raises exceptions" do
      expect { Pipe.get :loaded_data_obj, 1 }.to raise_error RuntimeError
      expect { Pipe.get :loaded_data_obj, qqqq: 4 }.to raise_error RuntimeError
      expect { Pipe.get :loaded_data_obj, data_obj_class: Main::Products }
        .to raise_error Pipe::MissingNeedOrInputError
      expect { Pipe.get :loaded_data_obj, data_obj_class: Main::Qqq }
        .to raise_error RuntimeError
      expect { Pipe.get :html, qqq: 4 }
        .to raise_error Pipe::MissingNeedOrInputError
    end
  end

  it "gets the data for data object" do
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
      loaded_data.should_receive(:empty?) { false }
      loaded_data.should_receive(:types).and_return [:products, :other]
      loaded_data.should_receive(:each)
        .and_yield(:products, "product items for #as_table_string")
        .and_yield(:qqq, "qqq items for #as_table_string")
      Support.should_receive(:as_table_string)
        .with("product items for #as_table_string") { "products table string\n" }
      Support.should_receive(:as_table_string)
        .with("qqq items for #as_table_string") { "qqq table string\n" }
      html = Pipe.get :html, loaded_data_obj: loaded_data

      expected_html =
        "HTML for products, other\n\n" <<
        "products:\n" <<
        "products table string\n" <<
        "qqq:\n" <<
        "qqq table string\n"

      expect(html).to eq expected_html
    end
  end
end
