describe "CartDetailsPage" do
  let(:cart) { double }
  let(:pipe) { double }
  subject(:cart_details_page) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    CartDetailsPage.new
  end

  def load_prepare_fakes(id)
    cart.stub(:load_from_db).with id: id, attribute_group: :details, limit: 1 
  end

  def html_prepare_fakes
    cart.stub(:loaded_to_hashes).and_return ["data1"]
    cart.stub(:data_obj_name).and_return "Carts"
    pipe.stub(:get).with(:html, data_by_type: {
      "Carts" => ["data1"],
    }).and_return "HTML for cart page"
  end

  before do
    stub_const "Page", Class.new
    stub_const "Main", Module.new
    stub_const "Main::Carts", Class.new
    stub_const "Pipe", Class.new

    Main::Carts.stub(:new).and_return cart
    Pipe.stub(:new) { pipe }
    Page.send(:define_method, :load) { |&block| block.call }
    Page.send(:define_method, :html) { |&block| block.call }
  end

  context "loads cart and makes html" do
    it "in two steps" do
      load_prepare_fakes 12
      cart_details_page.load 12

      html_prepare_fakes
      expect(cart_details_page.html).to eq "HTML for cart page"
    end

    it "in one step" do
      load_prepare_fakes 12
      html_prepare_fakes
      expect(cart_details_page.load_and_get_html id: 12).to eq "HTML for cart page"
    end
  end

  it "displays msg if no cart to load" do
    load_prepare_fakes 14
    cart_details_page.load 14

    cart.stub(:loaded_empty_result?).with(no_args).and_return true
    expect(cart_details_page.pipe_name_of_txt_if_empty_content).to eq :no_cart

    cart_details_page.stub(:html).and_return "No cart."
    expect(cart_details_page.html).to eq "No cart."
  end
end
