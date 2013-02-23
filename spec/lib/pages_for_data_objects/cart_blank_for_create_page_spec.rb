describe "CartBlankForCreatePage" do
  let(:cart) { double }
  let(:pipe) { double }
  subject(:cart_blank_for_create_page) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    CartBlankForCreatePage.new
  end

  def load_from_args_prepare_fakes
  end

  def html_prepare_fakes
    cart.should_receive(:attributes_of).and_return ["attribute names 1"]
    cart.should_receive(:data_obj_name).and_return "Carts"
    pipe.should_receive(:get).with(:html_for_create, data_by_type: {
      "Carts" => ["attribute names 1"],
    }).and_return "HTML for create cart page"
  end

  before do
    stub_const "Page", Class.new
    stub_const "Main", Module.new
    stub_const "Main::Carts", Class.new
    stub_const "Pipe", Class.new

    Main::Carts.stub(:new).and_return cart
    Pipe.stub(:new) { pipe }
    Page.send(:define_method, :load) { |&block| block.call if block_given? }
    Page.send(:define_method, :html) { |&block| block.call }
  end

  it "gets pipe" do
    expect(cart_blank_for_create_page.pipe).to eq pipe
  end

  context "loads cart and makes create fields html" do
    it "in two steps" do
      load_from_args_prepare_fakes
      cart_blank_for_create_page.load

      expect(cart_blank_for_create_page.pipe_name_of_txt_if_empty_content).to eq false

      html_prepare_fakes
      expect(cart_blank_for_create_page.html).to eq "HTML for create cart page"
    end

    it "in one step" do
      load_from_args_prepare_fakes
      html_prepare_fakes
      expect(cart_blank_for_create_page.load_and_get_html).to eq "HTML for create cart page"
    end
  end
end
