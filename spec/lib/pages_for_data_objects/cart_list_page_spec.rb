describe "CartListPage" do
  let(:carts) { double }
  subject(:cart_list_page) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    CartListPage.new
  end

  def load_prepare_fakes
    carts.should_receive(:load_from_db)
      .with attribute_group: :list_for_admin, order: :last, limit: 10
  end

  def html_prepare_fakes
    carts.should_receive(:html).and_return "HTML for list of last 10 carts"
  end

  before do
    stub_const "Page", Class.new
    stub_const "Main", Module.new
    stub_const "Main::Carts", Class.new

    Main::Carts.stub(:new).and_return carts
    Page.send(:define_method, :load) { |&block| block.call }
    Page.send(:define_method, :html) { |&block| block.call }
  end

  it "loads carts and makes html in two steps" do
    load_prepare_fakes
    cart_list_page.load

    html_prepare_fakes
    expect(cart_list_page.html).to eq "HTML for list of last 10 carts"
  end

  it "displays msg if no carts to load" do
    load_prepare_fakes
    cart_list_page.load

    carts.should_receive(:loaded_empty_result?).with(no_args).and_return true
    expect(cart_list_page.pipe_name_of_txt_if_empty_content).to eq :no_carts

    carts.should_receive(:html).and_return "No carts."
    expect(cart_list_page.html).to eq "No carts."
  end
end
