describe "ShowPage" do
  subject(:show_page) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    ShowPage.new
  end

  before do
    stub_const "Page", Class.new
  end

  it "raises error on execution" do
    expect { show_page.accomplish }.to raise_error RuntimeError
  end
end
