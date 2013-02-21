require(__FILE__.split('art_pazar/').first << '/art_pazar/lib/lib_loader.rb')

describe "In integration" do
  let(:controller) { Controller.new }

  xit "profiles..." do
  end

  context "visitor" do
    it "sees html for products" do
      Pipe::Fake.should_receive(:get_from_session).and_return false
      Pipe::Fake.should_receive(:param_if_exists).with(:id).and_return false
      expect(controller.action :list, :product).to eq "HTML for Products

Products:
NAME            PRICE
name value (0)  5.43
name value (1)  6.43
name value (2)  7.43
name value (3)  8.43
name value (4)  9.43
name value (5)  10.43
name value (6)  11.43
name value (7)  12.43
name value (8)  13.43
name value (9)  14.43
"
    end

    it "gets product page html" do
      Pipe::Fake.should_receive(:get_from_session).and_return false
      Pipe::Fake.should_receive(:param_if_exists).with(:id).and_return 16
      expect(controller.action :details, :product).to eq(
"HTML for Products, ProductSpecifications

Products:
NAME            PRICE  HEIGHT
name value (0)  5.43   12
ProductSpecifications:
SMALLINT_1  STRING_1    STRING_2    STRING_3
0           value1 (0)  value2 (0)  value3 (0)
")
    end
  end

  context "seller" do
    it "gets product create page html" do
      Pipe::Fake.should_receive(:get_from_session).and_return id: 14, type: :seller
      Pipe::Fake.should_receive(:param_if_exists).with(:id).and_return false
      expect(controller.action :blank_for_create, :product, product_type: :paintings).to eq(
"HTML for creating Products, ProductSpecifications with fields:

Products:
name, category_id, price
ProductSpecifications:
string_1, smallint_1, string_2, string_3
")
    end

    it "creates product and product specification" do
      Pipe::Fake.should_receive(:get_from_session).and_return id: 14, type: :seller
      Pipe::Fake.should_receive(:param_if_exists).with(:id).and_return false
      expect(controller.action :create, :product, product_type: :paintings).to eq true
      expect(controller.logs).to eq(
        ["Got params: name_Pr = name_Pr param val, category_id_Pr = category_id_Pr " <<
          "param val, price_Pr = price_Pr param val",
        "Got params: string_1_PrS " <<
          "= string_1_PrS param val, smallint_1_PrS = smallint_1_PrS param val, " <<
          "string_2_PrS = string_2_PrS param val, string_3_PrS = string_3_PrS param val",
        "Products creates name to name_Pr param val, category_id to " <<
          "category_id_Pr param val, price to price_Pr param val.",
        "ProductSpecifications creates string_1 to string_1_PrS param val, " <<
          "smallint_1 to smallint_1_PrS param val, string_2 to string_2_PrS " <<
          "param val, string_3 to string_3_PrS param val, product_id to 24."]
      )
    end

    it "gets product update page html" do
      Pipe::Fake.should_receive(:get_from_session).and_return id: 14, type: :seller
      Pipe::Fake.should_receive(:param_if_exists).with(:id).and_return 16
      expect(controller.action :blank_for_update, :product).to eq(
"HTML for updating Products, ProductSpecifications fields:

Products:
id was \"0\", name was \"name value (0)\", price was \"5.43\", category_id was \"12\"
ProductSpecifications:
id was \"0\", smallint_1 was \"0\", string_1 was \"value1 (0)\", string_2 was \"value2 (0)\", string_3 was \"value3 (0)\"
")
    end

    it "updates product and product specification" do
      Pipe::Fake.should_receive(:get_from_session).and_return id: 14, type: :seller
      Pipe::Fake.should_receive(:param_if_exists).with(:id).and_return 16
      expect(controller.action :update, :product).to eq true
      expect(controller.logs).to eq(
        ["Got params: id_Pr = id_Pr param val, name_Pr = name_Pr param val, " <<
        "category_id_Pr = category_id_Pr param val, price_Pr = price_Pr param val",
        "Got params: id_PrS = id_PrS param val, string_1_PrS = string_1_PrS param val, " <<
          "smallint_1_PrS = smallint_1_PrS param val, string_2_PrS = string_2_PrS param " <<
          "val, string_3_PrS = string_3_PrS param val",
        "Id id_Pr param val of Products updates name to name_Pr param val, category_id to " <<
          "category_id_Pr param val, price to price_Pr param val.",
        "Id id_PrS param val of ProductSpecifications updates string_1 to string_1_PrS " <<
          "param val, smallint_1 to smallint_1_PrS param val, string_2 to string_2_PrS " <<
          "param val, string_3 to string_3_PrS param val."]
      )
    end

    it "deletes product" do
      Pipe::Fake.should_receive(:get_from_session).and_return id: 14, type: :seller
      Pipe::Fake.should_receive(:param_if_exists).with(:id).and_return 16
      expect(controller.action :delete, :product).to eq true
      expect(controller.logs).to eq(
        ["Products with id = 16 is now deleted.",
          "ProductSpecifications with product_id = 16 is now deleted."]
      )
    end
  end
end
