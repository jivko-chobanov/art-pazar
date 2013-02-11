require(__FILE__.split('art_pazar/').first << '/art_pazar/lib/lib_loader.rb')

describe "In integration" do
  let(:home) { Home.new }
  let(:product_show_page) { ProductShowPage.new }
  let(:product_update_page) { ProductUpdatePage.new }
  let(:product_create_page) { ProductCreatePage.new }

  context "Home" do
    it "makes html for products" do
      expect(home.load_and_get_html).to eq "HTML for Products

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
  end

  context "ProductShowPage" do
    it "gets product page html"do
      expect(product_show_page.load_and_get_html).to eq(
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

  context "ProductUpdatePage" do
    it "gets product update page html" do
      expect(product_update_page.load_and_get_html 123).to eq(
"HTML for updating Products, ProductSpecifications fields:

Products:
name was \"name value (0)\", price was \"5.43\", category_id was \"12\"
ProductSpecifications:
smallint_1 was \"0\", string_1 was \"value1 (0)\", string_2 was \"value2 (0)\", string_3 was \"value3 (0)\"
")
    end

    it "updates product and product specification" do
      expect(product_update_page.load_and_accomplish 123).to eq true
      expect(product_update_page.pipe.logs).to eq(
        ["Got params: name_p, category_id_p, price_p",
        "Products updates name to name param val, category_id to category_id param val, " <<
          "price to price param val.",
        "Got params: string_1_ps, smallint_1_ps, string_2_ps, string_3_ps",
        "ProductSpecifications updates string_1 to string_1 param val, " <<
          "smallint_1 to smallint_1 param val, string_2 to string_2 param val, " <<
          "string_3 to string_3 param val."]
      )
    end
  end

  context "ProductCreatePage" do
    it "gets product create page html" do
      expect(product_create_page.load_and_get_html :paintings).to eq(
"HTML for creating Products, ProductSpecifications with fields:

Products:
name, category_id, price
ProductSpecifications:
string_1, smallint_1, string_2, string_3
")
    end

    it "creates product and product specification" do
      expect(product_create_page.load_and_accomplish :paintings).to eq true
      expect(product_create_page.pipe.logs).to eq(
        ["Got params: name_p, category_id_p, price_p",
        "Products creates name to name param val, category_id to category_id param val, " <<
          "price to price param val.",
        "Got params: string_1_ps, smallint_1_ps, string_2_ps, string_3_ps",
        "ProductSpecifications creates string_1 to string_1 param val, " <<
          "smallint_1 to smallint_1 param val, string_2 to string_2 param val, " <<
          "string_3 to string_3 param val."]
      )
    end
  end
end
