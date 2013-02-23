describe "UserDetailsPage" do
  let(:user) { double }
  let(:pipe) { double }
  subject(:user_details_page) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    UserDetailsPage.new
  end

  def load_prepare_fakes(id)
    user.should_receive(:load_from_db).with id: id, attribute_group: :details_for_registered, limit: 1
  end

  def html_prepare_fakes
    user.should_receive(:loaded_to_hashes).and_return ["data1"]
    user.should_receive(:data_obj_name).and_return "Users"
    pipe.should_receive(:get).with(:html, data_by_type: {
      "Users" => ["data1"],
    }).and_return "HTML for user page"
  end

  before do
    stub_const "Page", Class.new
    stub_const "Main", Module.new
    stub_const "Main::Users", Class.new
    stub_const "Pipe", Class.new

    Main::Users.stub(:new).and_return user
    Pipe.stub(:new) { pipe }
    Page.send(:define_method, :load) { |&block| block.call }
    Page.send(:define_method, :html) { |&block| block.call }
  end

  context "loads user and makes html" do
    it "in two steps" do
      load_prepare_fakes 12
      user_details_page.load 12

      html_prepare_fakes
      expect(user_details_page.html).to eq "HTML for user page"
    end

    it "in one step" do
      load_prepare_fakes 12
      html_prepare_fakes
      expect(user_details_page.load_and_get_html id: 12).to eq "HTML for user page"
    end
  end

  it "displays msg if no user to load" do
    load_prepare_fakes 14
    user_details_page.load 14

    user.should_receive(:loaded_empty_result?).with(no_args).and_return true
    expect(user_details_page.pipe_name_of_txt_if_empty_content).to eq :no_user

    user_details_page.should_receive(:html).and_return "No user."
    expect(user_details_page.html).to eq "No user."
  end
end
