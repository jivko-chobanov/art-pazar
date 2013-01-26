require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')

describe Home do
  it 'displays products' do
    home = Home.new

    expect { home.html }.to raise_error
    
    home.load
    
    expect(home.loaded_data).to have_key :products
    expect(home.ready_for_html?).to be_true
    expect(home.html).not_to be_nil and be_empty
  end
end
