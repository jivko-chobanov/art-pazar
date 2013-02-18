describe "User" do
  let(:pipe) { double }
  subject(:user) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    User.new
  end

  before :all do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
  end

  before do
    stub_const "Pipe", Class.new

    Pipe.stub(:new) { pipe }
  end

  context "when not logged in" do
    it "is a visitor" do
      expect(user.type).to eq :visitor
    end
  end

  context "when logging in" do
    it "authenticates" do
      username, password = "username ok", "pass ok"
      pipe.should_receive(:get)
        .with(:authentication_hash, username: username, password: password)
        .and_return type: :registered, name: "John"
      expect(user.authenticate username, password).to be_true
      expect(user.type).to eq :registered
    end

    it "fails if wrong input" do
      username, password = "username wrong", "pass wrong"
      pipe.should_receive(:get)
        .with(:authentication_hash, username: username, password: password)
        .and_return type: :visitor
      expect(user.authenticate username, password).to be_false
      expect(user.type).to eq :visitor
    end
  end
end
