require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')

describe LoadedData do
  before do
    stub_const "Support", Class.new
  end

  it "stores and gets" do
    loaded_data = LoadedData.new
    loaded_data.put "Products", "the data"
    loaded_data.put "Other", "other data"
    
    expect(loaded_data.get "Products").to eq "the data"

    expect(loaded_data.types).to include "Products"
    expect(loaded_data.types).to include "Other"

    expect { loaded_data.get :qqq }.to raise_error
    expect(loaded_data.to_hash).to eq "Products" => "the data", "Other" => "other data"
  end

  it "gets information about data" do
    loaded_data = LoadedData.new

    Support.stub(:empty?).with({}).and_return true
    expect(loaded_data.empty?).to be_true
    
    loaded_data.put "Products", "the data"

    Support.stub(:empty?).with("Products" => "the data").and_return false
    expect(loaded_data.empty?).to be_false

    empty_data = LoadedData.new

    empty_data.put "Products", ""
    Support.stub(:empty?).with("Products" => "").and_return true
    expect(empty_data.empty?).to be_true
  end
end
