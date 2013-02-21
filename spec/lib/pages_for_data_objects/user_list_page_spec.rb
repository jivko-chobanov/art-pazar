describe "UserListPage" do
  let(:users) { double }
  subject(:user_list_page) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    UserListPage.new
  end

  def load_prepare_fakes
    users.stub(:load_from_db)
      .with attribute_group: :list_for_admin, order: :last, limit: 10
  end

  def html_prepare_fakes
    users.stub(:html).and_return "HTML for list of last 10 users"
  end

  before do
    stub_const "Page", Class.new
    stub_const "Main", Module.new
    stub_const "Main::Users", Class.new

    Main::Users.stub(:new).and_return users
    Page.send(:define_method, :load) { |&block| block.call }
    Page.send(:define_method, :html) { |&block| block.call }
  end

  it "loads users and makes html in two steps" do
    load_prepare_fakes
    user_list_page.load

    html_prepare_fakes
    expect(user_list_page.html).to eq "HTML for list of last 10 users"
  end

  it "displays msg if no users to load" do
    load_prepare_fakes
    user_list_page.load

    users.stub(:loaded_empty_result?).with(no_args).and_return true
    expect(user_list_page.pipe_name_of_txt_if_empty_content).to eq :no_users

    users.stub(:html).and_return "No users."
    expect(user_list_page.html).to eq "No users."
  end
end
