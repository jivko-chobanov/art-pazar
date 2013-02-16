describe "ProductShowPage" do
  let(:product) { double }
  let(:product_specifications) { double }
  let(:pipe) { double }
  subject(:product_show_page) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    ProductShowPage.new
  end

  def load_prepare_fakes(id, type)
    product.stub(:load_from_db).with id: id, attribute_group: :for_visitor, limit: 1 
    product.should_receive(:type).and_return :paintings
    product_specifications.stub(:load_from_db)
      .with id: id, type: :paintings, attribute_group: :for_visitor, limit: 1 
  end

  def html_prepare_fakes
    product.stub(:runtime_table_hashes).and_return ["data1"]
    product_specifications.stub(:runtime_table_hashes).and_return ["data2"]
    product.stub(:data_obj_name).and_return "Products"
    product_specifications.stub(:data_obj_name).and_return "ProductSpecifications"
    pipe.stub(:get).with(:html, data_by_type: {
      "Products" => ["data1"],
      "ProductSpecifications" => ["data2"]
    }).and_return "HTML for product page"
  end

  before do
    stub_const "ShowPage", Class.new
    stub_const "Main", Module.new
    stub_const "Main::Products", Class.new
    stub_const "Main::ProductSpecifications", Class.new
    stub_const "Pipe", Class.new

    Main::Products.stub(:new).and_return product
    Main::ProductSpecifications.stub(:new).and_return product_specifications
    Pipe.stub(:new) { pipe }
    ShowPage.send(:define_method, :load) { |&block| block.call }
    ShowPage.send(:define_method, :html) { |&block| block.call }
  end

  context "loads product and makes html" do
    it "in two steps" do
      load_prepare_fakes 12, :paintings
      product_show_page.load 12

      html_prepare_fakes
      expect(product_show_page.html).to eq "HTML for product page"
    end

    it "in one step" do
      load_prepare_fakes 12, :paintings
      html_prepare_fakes
      expect(product_show_page.load_and_get_html 12).to eq "HTML for product page"
    end
  end

  it "displays msg if no product to load" do
    load_prepare_fakes 14, :paintings
    product_show_page.load 14

    product.stub(:loaded_empty_result?).with(no_args).and_return true
    expect(product_show_page.pipe_name_of_txt_if_empty_content).to eq :no_product

    product_show_page.stub(:html).and_return "No product."
    expect(product_show_page.html).to eq "No product."
  end
end
