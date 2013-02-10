describe "ProductUpdatePage" do
  let(:product) { double }
  let(:product_specifications) { double }
  let(:pipe) { double }
  subject(:product_update_page) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    ProductUpdatePage.new
  end

  def load_from_params_prepare_fakes
    product.stub(:load_from_params)
    product.should_receive(:type).and_return :paintings
    product_specifications.stub(:load_from_params).with type: :paintings
  end

  def load_from_db_prepare_fakes(id)
    product.stub(:load_from_db).with id: id, attribute_group: :for_update, limit: 1 
    product.should_receive(:type).and_return :paintings
    product_specifications.stub(:load_from_db)
      .with id: id, type: :paintings, attribute_group: :for_update, limit: 1 
  end

  def html_prepare_fakes
    product.stub(:loaded_data_hash_for_update).and_return "Products" => "data1"
    product_specifications.stub(:loaded_data_hash_for_update).and_return "Specifications" => "data2"
    pipe.stub(:get).with(:html_for_update, data_by_type: {
      "Products" => "data1",
      "Specifications" => "data2"
    }).and_return "HTML for update product page"
  end

  def accomplish_prepare_fakes
    product.should_receive(:attributes_of).with(:for_update).and_return [:name, :price]
    pipe.should_receive(:get).with(:params, names: [:name, :price], suffix: "_p")
      .and_return name: "new name", price: "new price"
    product.should_receive(:update).with(name: "new name", price: "new price")

    product_specifications.should_receive(:attributes_of).with(:for_update)
      .and_return [:name, :artist]
    pipe.should_receive(:get).with(:params, names: [:name, :artist], suffix: "_ps")
      .and_return name: "new name", artist: "new artist"
    product_specifications.should_receive(:update).with(name: "new name", artist: "new artist")
  end

  before do
    stub_const "UpdateOrCreatePage", Class.new
    stub_const "Main", Module.new
    stub_const "Main::Products", Class.new
    stub_const "Main::ProductSpecifications", Class.new
    stub_const "Pipe", Class.new

    Main::Products.stub(:new).and_return product
    Main::ProductSpecifications.stub(:new).and_return product_specifications
    Pipe.stub(:new) { pipe }
    UpdateOrCreatePage.send(:define_method, :load) { |&block| block.call }
    UpdateOrCreatePage.send(:define_method, :html) { |&block| block.call }
    UpdateOrCreatePage.send(:define_method, :accomplish) { |&block| block.call }
  end

  it "gets pipe" do
    expect(product_update_page.pipe).to eq pipe
  end

  context "loads product and makes update fields html" do
    it "in two steps" do
      load_from_db_prepare_fakes 12
      product_update_page.load_from_db 12

      product.stub(:loaded_empty_result?).with(no_args).and_return false
      expect(product_update_page.pipe_name_of_txt_if_empty_content).to eq false

      html_prepare_fakes
      expect(product_update_page.html).to eq "HTML for update product page"
    end

    it "in one step" do
    end
  end

  it "displays msg if no product to load" do
    load_from_db_prepare_fakes 12
    product_update_page.load_from_db 12

    product.stub(:loaded_empty_result?).with(no_args).and_return true
    expect(product_update_page.pipe_name_of_txt_if_empty_content).to eq :no_product

    product_update_page.stub(:html).and_return "No product."
    expect(product_update_page.html).to eq "No product."
  end

  context "updates product and its specification" do
    it "in two steps" do
      load_from_params_prepare_fakes
      product_update_page.load_from_params

      accomplish_prepare_fakes
      expect(product_update_page.accomplish).to be_true
    end

    it "in one step" do
    end
  end
end
