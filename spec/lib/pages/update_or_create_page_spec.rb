describe "UpdateOrCreatePage" do
  subject(:update_or_create_page) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    UpdateOrCreatePage.new
  end

  before :all do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
  end

  before do
    stub_const "Pipe", Class.new
    stub_const "Page", Class.new
  end
end
