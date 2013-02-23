describe "CartBlankForUpdatePage" do
  let(:cart) { double }
  let(:pipe) { double }
  subject(:cart_blank_for_update_page) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    CartBlankForUpdatePage.new
  end

  def load_from_db_prepare_fakes(id)
    cart.should_receive(:load_from_db).with id: id, attribute_group: :for_update, limit: 1
  end

  def html_prepare_fakes
    cart.should_receive(:loaded_to_hashes).and_return ["data1"]
    cart.should_receive(:data_obj_name).and_return "Carts"
    pipe.should_receive(:get).with(:html_for_update, data_by_type: {
      "Carts" => ["data1"],
    }).and_return "HTML for update cart page"
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

  it "gets pipe" do
    expect(cart_blank_for_update_page.pipe).to eq pipe
  end

  context "loads cart and makes update fields html" do
    it "in two steps" do
      load_from_db_prepare_fakes 12
      cart_blank_for_update_page.load 12

      cart.should_receive(:loaded_empty_result?).with(no_args).and_return false
      expect(cart_blank_for_update_page.pipe_name_of_txt_if_empty_content).to eq false

      html_prepare_fakes
      expect(cart_blank_for_update_page.html).to eq "HTML for update cart page"
    end

    it "in one step" do
      load_from_db_prepare_fakes 12
      html_prepare_fakes
      expect(cart_blank_for_update_page.load_and_get_html id: 12).to eq "HTML for update cart page"
    end
  end

  it "displays msg if no cart to load" do
    load_from_db_prepare_fakes 12
    cart_blank_for_update_page.load 12

    cart.should_receive(:loaded_empty_result?).with(no_args).and_return true
    expect(cart_blank_for_update_page.pipe_name_of_txt_if_empty_content).to eq :no_cart

    cart_blank_for_update_page.should_receive(:html).and_return "No cart."
    expect(cart_blank_for_update_page.html).to eq "No cart."
  end
end
