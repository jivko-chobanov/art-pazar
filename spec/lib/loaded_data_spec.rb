describe "Table" do
  subject(:table) do
    require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')
    Table.new
  end

  before :all do
    require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')
  end

  before do
    stub_const "Support", Class.new
  end

  it "stores, replaces and gets" do
    table.put "Products", "the old data"
    table.put "Other", "other data"

    expect { table.put "Products", "the data" }.to raise_error RuntimeError
    expect { table.replace "Qqq", "the data" }.to raise_error RuntimeError

    table.replace "Products", "the data"
    
    expect(table.get "Products").to eq "the data"

    expect(table.types).to include "Products"
    expect(table.types).to include "Other"

    expect { table.get :qqq }.to raise_error RuntimeError
    expect(table.to_hash).to eq "Products" => "the data", "Other" => "other data"
  end

  it "changes hashes of data type" do
    table.put "Products", name1: :val1, name2: :val2
    table.merge_to "Products", new_name: :new_val
    expect(table.get "Products").to eq name1: :val1, name2: :val2, new_name: :new_val
  end

  it "gets information about data" do
    Support.stub(:empty?).with({}).and_return true
    expect(table.empty?).to be_true
    
    table.put "Products", "the data"

    Support.stub(:empty?).with("Products" => "the data").and_return false
    expect(table.empty?).to be_false

    empty_data = Table.new

    empty_data.put "Products", ""
    Support.stub(:empty?).with("Products" => "").and_return true
    expect(empty_data.empty?).to be_true
  end
end
