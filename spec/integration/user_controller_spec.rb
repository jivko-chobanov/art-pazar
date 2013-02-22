require(__FILE__.split('art_pazar/').first << '/art_pazar/lib/lib_loader.rb')

describe "In integration" do
  let(:controller) { RequestController.new }
  let(:visitor) { user_of_type :visitor }
  let(:registered) { user_of_type :registered }
  let(:seller) { user_of_type :seller }
  let(:admin) { user_of_type :admin }

  def user_of_type(type, id = 14, id_from_params = 14)
    Pipe::Fake.should_receive(:get_from_session).and_return id: id, type: type
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

  context "(privileges)" do
    it "gets filters for data_object for access to be allowed" do
      expect(visitor.get_filters_if_access :list, :product).to eq published: true
      expect(visitor.get_filters_if_access :create, :product).to be_false
      expect(visitor.get_filters_if_access :qqq, :product).to be_false
      expect(visitor.get_filters_if_access :list, :qqq).to be_false

      expect(registered.get_filters_if_access :details, :user).to eq id: 14

      expect(seller.get_filters_if_access :blank_for_create, :product).to eq user_id: 14
      expect(seller.get_filters_if_access :create, :product).to eq user_id: 14

      expect(admin.get_filters_if_access :create, :product).to eq({})
    end

    it "inherits privileges" do
      expect(seller.get_filters_if_access :list, :product).to eq [{published: true}, {user_id: 14}]
      expect(seller.get_filters_if_access :update, :user).to eq id: 14

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
      expect(visitor.login).to be_true
      expect(visitor.type).to eq "type value (0)"
    end
  end
end
