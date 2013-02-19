describe "User" do
  let(:pipe) { double }
  let(:runtime_table) { double }
  let(:row) { double }
  subject(:user) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    User.new
  end

  before :all do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
  end

  before do
    stub_const "Pipe", Class.new
    stub_const "RuntimeTable", Class.new

    Pipe.stub(:new) { pipe }
    RuntimeTable.stub(:new) { runtime_table }
    runtime_table.stub(:row).and_return row
  end

  context "when not logged in" do
    it "is a visitor" do
      expect(user.type).to eq :visitor
    end

    it "identifies using session" do
      pipe.should_receive(:get).with(:successful_authentication_in_session)
        .and_return id: 14, type: :registered
      row.should_receive(:<<).with(id: 14, type: :registered)
      row.should_receive(:type).and_return :registered
      user.identify_using_session
      expect(user.type).to eq :registered
    end
  end

  context "when logging in" do
    it "#login" do
      user_hash = {username: "un", password: "pass", id: 14, type: :registered}
      pipe.should_receive(:get).with(:params, names: %w{username password})
        .and_return username: "un", password: "pass"
      pipe.should_receive(:get).with(:runtime_table_hashes,
        {attribute_group: :for_login, username: "un", password: "pass"}).and_return user_hash
      row.should_receive(:<<).with(user_hash)
      row.should_receive(:id).and_return 14
      row.should_receive(:type).and_return :registered
      pipe.should_receive(:put)
        .with(:successful_authentication_in_session, id: 14, type: :registered)
      expect(user.login).to be_true
      expect(user.type).to eq :registered
    end

    it "false if wrong input" do
      pipe.should_receive(:get).with(:params, names: %w{username password})
        .and_return username: "wrong un", password: "wrong pass"
      pipe.should_receive(:get).with(:runtime_table_hashes,
        {attribute_group: :for_login, username: "wrong un", password: "wrong pass"})
        .and_return({})
      expect(user.login).to be_false
      expect(user.type).to eq :visitor
    end
  end
end
