describe "RequestController" do
  let(:pipe) { double }
  let(:product_list_page) { double }
  let(:user) { double }
  let(:product_details_page) { double }
  let(:user_update_operation) { double }
  let(:user_create_operation) { double }
  subject(:controller) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    RequestController.new
  end

  before :all do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
  end

  before do
    stub_const "Pipe", Class.new
    stub_const "Support", Class.new
    stub_const "ProductListPage", Class.new
    stub_const "ProductDetailsPage", Class.new
    stub_const "UserUpdateOperation", Class.new
    stub_const "UserCreateOperation", Class.new
    stub_const "UserController", Class.new

    Pipe.stub(:new) { pipe }
    ProductListPage.stub(:new) { product_list_page }
    ProductDetailsPage.stub(:new) { product_details_page }
    UserUpdateOperation.stub(:new) { user_update_operation }
    UserCreateOperation.stub(:new) { user_create_operation }
    UserController.stub(:new).with(kind_of(Hash), kind_of(Hash), kind_of(Array)) { user }
  end

  it "gives action log" do
    controller.instance_variable_set :@action, user_create_operation
    user_create_operation.should_receive(:pipe).and_return pipe
    pipe.should_receive(:logs).and_return "the logs"
    expect(controller.logs).to eq "the logs"
  end

  context "applies filters to the right page and data_object" do
    it "if no data_object id" do
      user.should_receive(:get_filters_if_access).with(:list, :product)
        .and_return published: true
      Support.should_receive(:to_camel_string).with(:list).and_return "List"
      Support.should_receive(:to_camel_string).with(:product).and_return "Product"
      Support.should_receive(:to_camel_string).with(:page).and_return "Page"
      pipe.should_receive(:get).with(:param_if_exists, param_name: :id).and_return false
      product_list_page.should_receive(:load_and_get_html).with(published: true)
        .and_return "ProductListPage HTML"
      expect(controller.action :list, :product).to be_true
    end

    it "if params have data_object id" do
      user.should_receive(:get_filters_if_access).with(:details, :product)
        .and_return published: true
      Support.should_receive(:to_camel_string).with(:details).and_return "Details"
      Support.should_receive(:to_camel_string).with(:product).and_return "Product"
      Support.should_receive(:to_camel_string).with(:page).and_return "Page"
      pipe.should_receive(:get).with(:param_if_exists, param_name: :id).and_return 12
      product_details_page.should_receive(:load_and_get_html).with(id: 12, published: true)
        .and_return "Product page HTML"
      expect(controller.action :details, :product).to be_true
    end
  end

  context "applies filters to the right operation and data_object" do
    it "if no data_object id and :a1, :a2 passed as tail args to action" do
      user.should_receive(:get_filters_if_access).with(:create, :user)
        .and_return userid: 14
      Support.should_receive(:to_camel_string).with(:create).and_return "Create"
      Support.should_receive(:to_camel_string).with(:user).and_return "User"
      Support.should_receive(:to_camel_string).with(:operation).and_return "Operation"
      pipe.should_receive(:get).with(:param_if_exists, param_name: :id).and_return false
      user_create_operation.should_receive(:load_and_accomplish).with(userid: 14, k: :v)
        .and_return "Blank"
      expect(controller.action :create, :user, k: :v).to be_true
    end

    it "if params have data_object id and filters are many, joined with or" do
      user.should_receive(:get_filters_if_access).with(:update, :user)
        .and_return [userid: 14, another: :filter]
      Support.should_receive(:to_camel_string).with(:update).and_return "Update"
      Support.should_receive(:to_camel_string).with(:user).and_return "User"
      Support.should_receive(:to_camel_string).with(:operation).and_return "Operation"
      pipe.should_receive(:get).with(:param_if_exists, param_name: :id).and_return 73
      user_update_operation.should_receive(:load_and_accomplish)
        .with(id: 73, or_conditions: [userid: 14, another: :filter]).and_return "Blank"
      expect(controller.action :update, :user).to be_true
    end
  end

  context "raises error if no access" do
    it "create product" do
      user.should_receive(:get_filters_if_access).with(:create, :product).and_return false
      expect { controller.action :create, :product }.to raise_error RuntimeError
    end
  end
end
