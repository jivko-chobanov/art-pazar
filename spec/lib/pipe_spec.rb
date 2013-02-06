require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')

describe Pipe do
  let(:pipe) { Pipe.new }

  before :each do
    stub_const "Support", Class.new
  end

  context "when undefined command" do
    it "raises exceptions" do
      expect { pipe.get :loaded_data_obj_content, 1 }.to raise_error RuntimeError
      expect { pipe.get :loaded_data_obj_content, qqqq: 4 }.to raise_error RuntimeError
      expect { pipe.get :loaded_data_obj_content, data_obj_name: "Products" }
        .to raise_error Pipe::MissingNeedOrInputError
      expect { pipe.get :loaded_data_obj_content, data_obj_name: "Qqq" }
        .to raise_error RuntimeError
      expect { pipe.get :html, qqq: 4 }
        .to raise_error Pipe::MissingNeedOrInputError
    end
  end

  it "gets the data for data object" do
    three_products_for_listing = pipe.get(:loaded_data_obj_content, {
      data_obj_name: "Products",
      attributes: [:name, :price],
      limit: 3
    })
    expect(three_products_for_listing.count).to be 3
    expect(three_products_for_listing.first.keys).to eq [:name, :price]
  end

  it "gets logged actions" do
    pipe.send :log, "action log"
    expect(pipe.last_logged).to eq "action log"

    pipe.send :log, "action log 2"
    expect(pipe.logs).to eq ["action log", "action log 2"]
  end

  it "updates a record in the database" do
    expect(pipe.put "Products", id: 12, name: "new name", price: 2).to be_true
    expect(pipe.last_logged).to eq "Id 12 of Products updates name to new name, price to 2."
  end

  unless defined? Rails
    it "generates txt messages" do
      expect(pipe.get :txt, txt: :no_products_for_home_page).not_to be_empty
    end

    it "generates fake html" do
      Support.stub(:as_table_string)
        .with("product items for #as_table_string") { "products table string\n" }
      Support.stub(:as_table_string)
        .with("qqq items for #as_table_string") { "qqq table string\n" }

      html = pipe.get :html, {
        data_by_type: {
          "Products" => "product items for #as_table_string",
          "Qqq"      => "qqq items for #as_table_string"
        }
      }

      expected_html =
        "HTML for Products, Qqq\n\n" <<
        "Products:\n" <<
        "products table string\n" <<
        "Qqq:\n" <<
        "qqq table string\n"

      expect(html).to eq expected_html
    end
  end
end
