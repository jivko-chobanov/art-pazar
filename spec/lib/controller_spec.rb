describe "Controller" do
  let(:pipe) { double }
  let(:product_list_page) { double }
  let(:user) { double }
  let(:product_details_page) { double }
  subject(:controller) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    Controller.new
  end

  before :all do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
  end

  before do
    stub_const "Pipe", Class.new
    stub_const "Support", Class.new
    stub_const "ProductListPage", Class.new
    stub_const "ProductDetailsPage", Class.new
    stub_const "User", Class.new

    Pipe.stub(:new) { pipe }
    ProductListPage.stub(:new) { product_list_page }
    ProductDetailsPage.stub(:new) { product_details_page }
    User.stub(:new) { user }
    user.should_receive(:identify).with(no_args)
    user.should_receive(:privileges=).with(kind_of Hash)
  end

  context "when wrong" do
    before do
      user.should_receive(:can).and_return true
    end

    it "not existing thing to see" do
      Support.should_receive(:to_camel).with(:details).and_return "Details"
      Support.should_receive(:to_camel).with(:qqq).and_return "Qqq"
      Support.should_receive(:to_camel).with(:page).and_return "Page"
      expect { controller.action :details, :qqq }.to raise_error RuntimeError
    end
  end

  context "visitor" do
    context "can" do
      before do
        user.should_receive(:can).and_return true
      end

      it "see a list of products" do
        product_list_page.should_receive(:load_and_get_html).and_return "ProductListPage HTML"
        Support.should_receive(:to_camel).with(:list).and_return "List"
        Support.should_receive(:to_camel).with(:product).and_return "Product"
        Support.should_receive(:to_camel).with(:page).and_return "Page"
        pipe.should_receive(:get).with(:param_if_exists, :id).and_return false
        expect(controller.action :list, :product).to be_true
      end

      it "see product details" do
        product_details_page.should_receive(:load_and_get_html).and_return "Product page HTML"
        Support.should_receive(:to_camel).with(:details).and_return "Details"
        Support.should_receive(:to_camel).with(:product).and_return "Product"
        Support.should_receive(:to_camel).with(:page).and_return "Page"
        pipe.should_receive(:get).with(:param_if_exists, :id).and_return 12
        expect(controller.action :details, :product).to be_true
      end
    end

#   context "cannot" do
#     it "" do
#     end
#   end
  end
end
__END__
  context "registered" do
    context "can" do
    end
  end

  context "sellers" do
    before do
      user.should_receive(:can).and_return true
    end

#   before do
#     user.authenticate "username seller ok", "password seller ok"
#   end

    context "can operate with their own" do
      it "products" do
        expect(controller.action :blank_for_create, :product).to be_true
        expect(controller.action :create, :product).to be_true
        expect(controller.action :blank_for_update, :product).to be_true
        expect(controller.action :update, :product).to be_true
        expect(controller.action :delete, :product).to be_true
      end

      it "profile" do
        expect(controller.action :blank_for_create, :user).to be_true
        expect(controller.action :create, :user).to be_true
        expect(controller.action :blank_for_update, :user).to be_true
        expect(controller.action :update, :user).to be_true
        expect(controller.action :delete, :user).to be_true
      end
    end
  end
end
__END__
  context "admin" do
    before do
#     user.authenticate "username admin ok", "password admin ok"
    end

    context "can publish" do
      it "products" do
      end
    end

    context "can operate with any" do
      it "products" do
      end

      it "profiles" do
      end
    end
  end
end
