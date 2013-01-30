require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")

describe Home do
  it "displays products" do
    home = Home.new

    expect { home.html }.to raise_error
    expect(home.tried_to_load).to be_false
    
    home.load
    expect(home.tried_to_load).to be_true
    expect { home.load }.to raise_error
    
    expect(home.html).not_to be_nil
    expect(home.html).not_to be_empty
  end

  it "displays msg if no products to load" do
    home = Home.new
    home.load
    home.instance_variable_get(:@products).stub(:loaded_empty_result?) { true }
    expect(home.html).to eq Pipe.get(:txt, txt: :no_products_for_home_page)
  end
end
