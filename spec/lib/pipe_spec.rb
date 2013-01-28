require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')

module Main
  class Product
    def self.get_attributes(name)
      [:name, :price]
    end
  end

  class Qqq
  end
end

describe Pipe do
  it "raises exceptions when undefined command" do
    expect { Pipe.get :data, 1 }.to raise_error
    expect { Pipe.get :data, qqqq: 4 }.to raise_error
    expect { Pipe.get :data, data_obj_class: Main::Product }.to raise_error(
      Pipe::MissingNeedOrInputError
    )
    expect { Pipe.get :data, data_obj_class: Main::Qqq }.to raise_error
    expect { Pipe.get :html, qqq: 4 }.to raise_error(
      Pipe::MissingNeedOrInputError
    )
  end

  it "gets from data object" do
    three_products_for_listing = Pipe.get(:data, {
      data_obj_class: Main::Product,
      attribute_group: :list,
      limit: 3
    })
    expect(three_products_for_listing.count).to be 3
    expect(three_products_for_listing.first.keys).to eq Main::Product.get_attributes(:list)
  end

  unless defined? Rails
    it "displays fake html" do
      three_products_for_listing = Pipe.get(:data, {
        data_obj_class: Main::Product,
        attribute_group: :list,
        limit: 3
      })
      html = Pipe.get :html, data: {products: three_products_for_listing}
      expected_html =
        "HTML for products\n\n" <<
        "products:\n" <<
        "name            price\n" <<
        "name value (0)  5.43\n" <<
        "name value (1)  6.43\n" <<
        "name value (2)  7.43\n"

      expect(html.lines.first).to eq expected_html.lines.first
      expect(html.lines.to_a[1]).to eq expected_html.lines.to_a[1]
      expect(html.lines.to_a[2]).to eq expected_html.lines.to_a[2]
      expect(html.lines.to_a[3]).to eq expected_html.lines.to_a[3]
      expect(html).to eq expected_html
    end
  end
end
