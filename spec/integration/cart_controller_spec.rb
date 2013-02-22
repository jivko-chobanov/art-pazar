require(__FILE__.split('art_pazar/').first << '/art_pazar/lib/lib_loader.rb')

describe "In integration" do
  let(:controller) { RequestController.new }

  context "registered" do
    it "gets cart page html" do
      Pipe::Fake.should_receive(:get_from_session).and_return id: 14, type: :registered
      Pipe::Fake.should_receive(:param_if_exists).with(:id).and_return 83
      expect(controller.action :details, :cart).to eq(
"HTML for Carts

Carts:
ID  BUYER_ID  SELLER_ID
0   0         0
")
    end

    it "gets cart create page html" do
      Pipe::Fake.should_receive(:get_from_session).and_return id: 14, type: :seller
      Pipe::Fake.should_receive(:param_if_exists).with(:id).and_return false
      expect(controller.action :blank_for_create, :cart).to eq(
"HTML for creating Carts with fields:

Carts:
buyer_id, seller_id
")
    end

    it "creates cart" do
      Pipe::Fake.should_receive(:get_from_session).and_return id: 14, type: :seller
      Pipe::Fake.should_receive(:param_if_exists).with(:id).and_return false
      expect(controller.action :create, :cart).to eq true
      expect(controller.logs).to eq(
        ["Got params: buyer_id_C = buyer_id_C param val, " <<
          "seller_id_C = seller_id_C param val",
        "Carts creates buyer_id to buyer_id_C param val, " <<
          "seller_id to seller_id_C param val."]
      )
    end

    it "gets cart update page html" do
      Pipe::Fake.should_receive(:get_from_session).and_return id: 14, type: :seller
      Pipe::Fake.should_receive(:param_if_exists).with(:id).and_return 16
      expect(controller.action :blank_for_update, :cart).to eq(
%q{HTML for updating Carts fields:

Carts:
id was "0", buyer_id was "0", seller_id was "0"
})
    end

    it "updates cart" do
      Pipe::Fake.should_receive(:get_from_session).and_return id: 14, type: :seller
      Pipe::Fake.should_receive(:param_if_exists).with(:id).and_return 16
      expect(controller.action :update, :cart).to eq true
      expect(controller.logs).to eq(
        ["Got params: id_C = id_C param val, buyer_id_C = buyer_id_C param val, " <<
          "seller_id_C = seller_id_C param val",
        "Id id_C param val of Carts updates buyer_id to buyer_id_C param val, " <<
          "seller_id to seller_id_C param val."]
      )
    end

    it "deletes cart" do
      Pipe::Fake.should_receive(:get_from_session).and_return id: 16, type: :seller
      Pipe::Fake.should_receive(:param_if_exists).with(:id).and_return 16
      expect(controller.action :delete, :cart).to eq true
      expect(controller.logs).to eq(
        ["Carts with id = 16 is now deleted."]
      )
    end
  end

  context "seller" do
  end

  context "admin" do
    it "sees html for carts" do
      Pipe::Fake.should_receive(:get_from_session).and_return id: 16, type: :admin
      Pipe::Fake.should_receive(:param_if_exists).with(:id).and_return false
      expect(controller.action :list, :cart).to eq "HTML for Carts

Carts:
ID  BUYER_ID  SELLER_ID
0   0         0
1   1         1
2   2         2
3   3         3
4   4         4
5   5         5
6   6         6
7   7         7
8   8         8
9   9         9
"
    end
  end
end
