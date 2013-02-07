require(__FILE__.split('art_pazar/').first << '/art_pazar/lib/lib_loader.rb')

describe Home do
  context "in integration:" do
    it "makes html for products" do
      expect(Home.new.load_and_get_html).to eq "HTML for Products

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
end

describe ProductShowPage do
  context "in integration:" do
    it "gets product page html"do
      expect(ProductShowPage.new(:paintings).load_and_get_html).to eq(
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
end

describe ProductUpdatePage do
  context "in integration:" do
    it "gets product update page html" do
      expect(ProductUpdatePage.new.load_and_get_html).to eq "HTML for updating Products fields: name was \"name value (0)\", price was \"5.43\", category_id was \"12\""
    end
  end
end

describe ProductCreatePage do
  context "in integration:" do
    it "gets product create page html" do
      expect(ProductCreatePage.new.load_and_get_html).to eq "HTML for creating Products with fields: name, category_id, price"
    end
  end
end
