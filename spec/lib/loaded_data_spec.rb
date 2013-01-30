require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')

describe LoadedData do
  it "stores and gets" do
    loaded_data = LoadedData.new
    loaded_data.put :product, "the data"
    loaded_data.put :other, "other data"
    
    expect(loaded_data.get :product).to eq "the data"

    expect(loaded_data.types).to include :product
    expect(loaded_data.types).to include :other

    expect { loaded_data.get :qqq }.to raise_error
  end

  it "gets information about data" do
    loaded_data = LoadedData.new

    expect(loaded_data.empty?).to be_true
    loaded_data.put :product, "the data"
    expect(loaded_data.empty?).to be_false

    empty_data = LoadedData.new
    empty_data.put :product, ""
    expect(empty_data.empty?).to be_true
    empty_data.put :other, {}
    expect(empty_data.empty?).to be_true
    empty_data.put :other2, []
    expect(empty_data.empty?).to be_true
  end
end
