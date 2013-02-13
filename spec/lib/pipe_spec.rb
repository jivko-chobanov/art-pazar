describe "Pipe" do
  let(:pipe) do
    require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')
    Pipe.new
  end

  before :all do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
  end

  before :each do
    stub_const "Support", Class.new
    stub_const "Main", Class.new
    stub_const "Main::AnyDataObject", Class.new
  end

  context "when undefined command" do
    it "raises exceptions" do
      expect { pipe.get :table_obj_content, 1 }.to raise_error RuntimeError
      expect { pipe.get :table_obj_content, qqqq: 4 }.to raise_error RuntimeError
      expect { pipe.get :table_obj_content, data_obj_name: "Products" }
        .to raise_error Pipe::MissingNeedOrInputError
      expect { pipe.get :table_obj_content, data_obj_name: "Qqq" }
        .to raise_error RuntimeError
      expect { pipe.get :html, qqq: 4 }
        .to raise_error Pipe::MissingNeedOrInputError
    end
  end

  it "gets the data for data object" do
    three_products_for_listing = pipe.get(:table_obj_content, {
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

  unless defined? Rails
    it "gets last created id of data_obj_name (fake)" do
      expect(pipe.get :last_created_id, data_obj_name: "any").to be_> 0
      expect { pipe.get :last_created_id, "other" }.to raise_error RuntimeError
    end

    it "creates a record in the database" do
      expect(pipe.put "Products", name: "new name", price: 2).to be_true
      expect(pipe.last_logged).to eq "Products creates name to new name, price to 2."
    end

    it "updates a record in the database" do
      expect(pipe.put "Products", id: 12, name: "new name", price: 2).to be_true
      expect(pipe.last_logged).to eq "Id 12 of Products updates name to new name, price to 2."
    end

    it "generates txt messages" do
      expect(pipe.get :txt, txt: :no_products_for_home_page).not_to be_empty
    end

    context "when fake params are wanted" do
      it "gets them for data object" do
        expect(pipe.get :params, names: [:name, :price])
          .to eq name: "name param val", price: "price param val"
      end

      it "raises error on same param name twice in the list" do
        expect { pipe.get :params, names: %w{name any name other} }.to raise_error RuntimeError
      end
    end

    context "when fake html is wanted" do
      context "when data is ok" do
        it "generates data object visualization" do
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

        it "generates update fields" do
          html = pipe.get :html_for_update, {
            data_by_type: {
              "Products" => [{name: "old name", category_id: 1, price: 2}],
              "Other" => [{name: "old name2", other_attr: 5, price: 2}],
            }
          }

          expect(html).to eq(
            "HTML for updating Products, Other fields:\n\n" <<
            "Products:\n" <<
            "name was \"old name\", category_id was \"1\", price was \"2\"\n" <<
            "Other:\n" <<
            "name was \"old name2\", other_attr was \"5\", price was \"2\"\n"
          )
        end

        it "generates create fields" do
          html = pipe.get :html_for_create, {
            data_by_type: {
              "Products" => [[:name, :category_id, :price]],
              "Other" => [[:name, :other_attr, :price]],
            }
          }

          expect(html).to eq(
            "HTML for creating Products, Other with fields:\n\n" <<
            "Products:\n" <<
            "name, category_id, price\n" <<
            "Other:\n" <<
            "name, other_attr, price\n"
          )
        end
      end

      context "when data is empty" do
        it "generates html" do
          html = pipe.get :html, {
            data_by_type: {}
          }

          expect(html).to eq "HTML for empty data"
        end

        it "raises error for create fields" do
          expect { pipe.get :html_for_create, { data_by_type: {} } }.to raise_error RuntimeError
        end

        it "raises error for update fields" do
          expect { pipe.get :html_for_update, { data_by_type: {} } }.to raise_error RuntimeError
        end
      end
    end
  end
end
