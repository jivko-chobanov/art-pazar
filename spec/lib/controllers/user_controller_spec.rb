describe "UserController" do
  let(:pipe) { double }
  let(:user) { double }
  subject(:visitor) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    user_of_type :visitor
  end

  before :all do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
  end

  def user_of_type(type)
    if type == :visitor
      pipe.should_receive(:get).with(:successful_authentication_in_session).and_return false
    else
      pipe.should_receive(:get).with(:successful_authentication_in_session)
        .and_return id: 14, type: type
      user.should_receive(:set).with(id: 14, type: type)
      user.should_receive(:type).and_return type
      user.should_receive(:id).and_return 14
    end
    UserController.new({
        see: [:list, :details],
        create: [:create, :blank_for_create],
        update: [:update, :blank_for_update],
      }, {
        visitor: {product: {published: [:see]}},
        registered: {
          user: {own: [:see, :create, :update, :delete]},
        },
        seller: {
          product: {own: [:see, :create, :update, :delete]},
        },
        admin: {
          product: {all: [:see, :create, :update, :delete, :publish]},
          user: {all: [:see, :create, :update, :delete]},
        },
      },
      [:visitor, :registered, :seller, :admin]
    )
  end

  before do
    stub_const "Pipe", Class.new
    stub_const "Main", Class.new
    stub_const "Main::Users", Class.new

    Pipe.stub(:new) { pipe }
    Main::Users.stub(:new) { user }
  end
  
  context "(privileges)" do
    it "gets filters for data_object for access to be allowed" do
      expect(visitor.get_filters_if_access :list, :product).to eq published: true
      expect(visitor.get_filters_if_access :create, :product).to be_false
      expect(visitor.get_filters_if_access :qqq, :product).to be_false
      expect(visitor.get_filters_if_access :list, :qqq).to be_false

      registered = user_of_type :registered
      expect(registered.get_filters_if_access :details, :user).to eq id: 14

      seller = user_of_type :seller
      expect(seller.get_filters_if_access :blank_for_create, :product).to eq user_id: 14
      expect(seller.get_filters_if_access :create, :product).to eq user_id: 14

      admin = user_of_type :admin
      expect(admin.get_filters_if_access :create, :product).to eq({})
    end

    it "inherits privileges" do
      seller = user_of_type :seller 
      expect(seller.get_filters_if_access :list, :product).to eq [{published: true}, {user_id: 14}]
      expect(seller.get_filters_if_access :update, :user).to eq id: 14

      admin = user_of_type :admin 
      expect(admin.get_filters_if_access :publish, :product).to eq({})
      expect(admin.get_filters_if_access :delete, :product).to eq({})
      expect(admin.get_filters_if_access :list, :product).to eq({})
    end
  end

  context "when not logged in" do
    it "is a visitor" do
      expect(visitor.type).to eq :visitor
    end
  end

  context "when logging in" do
    it "#login" do
      user_hash = {username: "un", password: "pass", id: 14, type: :registered}
      pipe.should_receive(:get).with(:params, names: [:username, :password])
        .and_return username: "un", password: "pass"
      pipe.should_receive(:get).with(:runtime_table_hashes,
        {attribute_group: :for_login, username: "un", password: "pass"}).and_return user_hash
      user.should_receive(:set).with(user_hash)
      user.should_receive(:id).and_return 14
      user.should_receive(:type).and_return :registered
      pipe.should_receive(:put)
        .with(:successful_authentication_in_session, id: 14, type: :registered)
      expect(visitor.login).to be_true
      expect(visitor.type).to eq :registered
    end

    it "false if wrong input" do
      pipe.should_receive(:get).with(:params, names: [:username, :password])
        .and_return username: "wrong un", password: "wrong pass"
      pipe.should_receive(:get).with(:runtime_table_hashes,
        {attribute_group: :for_login, username: "wrong un", password: "wrong pass"})
        .and_return({})
      expect(visitor.login).to be_false
      expect(visitor.type).to eq :visitor
    end
  end
end
