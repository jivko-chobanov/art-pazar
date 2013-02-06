require(__FILE__.split('art_pazar/').first << '/art_pazar/lib/lib_loader.rb')

describe Home do
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
