describe "Support" do
  before :all do
    require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')
  end

  it "adds suffix to array" do
    expect(Support.add_suffix ["abc", "efg"], " is ok").to eq ["abc is ok", "efg is ok"]
    expect(Support.add_suffix [], " is ok").to eq []
    expect(Support.add_suffix ["abc", "efg"], "").to eq ["abc", "efg"]
  end

  it "removes suffix from the keys of a hash" do
    expect(Support.remove_suffix_from_keys({abc_ok: "lala", efg_ok: "koko"}, "_ok")).to eq(
      {abc: "lala", efg: "koko"})
    expect(Support.remove_suffix_from_keys({abc_ok: "lala", efg: "koko"}, "_ok")).to eq(
      {abc: "lala", efg: "koko"})

    expect(
      Support.remove_suffix_from_keys({"abc_ok" => "lala_ok", "efg_ok" => "koko_ok"}, "_ok")
    ).to eq "abc" => "lala_ok", "efg" => "koko_ok"

    expect(Support.remove_suffix_from_keys({"abc_ok" => "lala", "efg_ok" => "koko"}, "")).to eq(
      {"abc_ok" => "lala", "efg_ok" => "koko"})
    expect(Support.remove_suffix_from_keys({}, "_ok")).to eq({})
  end

  it "transforms ordered array of hashes with keys = column names to string which looks like table in the console with labeled columns on the top" do
    html = Support.as_table_string([
      {name: "My name", price: 5.43},
      {name: "Grogry", price: 8},
      {name: "Jocker Madagona", price: 99.2}
    ])
    expected_html =
      "NAME             PRICE\n" <<
      "My name          5.43\n" <<
      "Grogry           8\n" <<
      "Jocker Madagona  99.2\n"

    expect(html.lines.first).to eq expected_html.lines.first
    expect(html.lines.to_a[1]).to eq expected_html.lines.to_a[1]
    expect(html).to eq expected_html
  end

  it "checks if something of any kind is empty" do
    expect(Support.empty? 0).to be_true
    expect(Support.empty? "").to be_true
    expect(Support.empty? []).to be_true
    expect(Support.empty?({})).to be_true
    expect(Support.empty? nil).to be_true
    expect(Support.empty? 0.0).to be_true
    expect(Support.empty? false).to be_true

    expect(Support.empty? -1).to be_false
    expect(Support.empty? "0").to be_false
    expect(Support.empty? [0]).to be_false
    expect(Support.empty? a: 1).to be_false
    expect(Support.empty? 0.1).to be_false
    expect(Support.empty? true).to be_false

    expect(Support.empty? a: 0, b: "", c: [], d: {}, e: nil, f: 0.0, h: false).to be_true
  end
end
