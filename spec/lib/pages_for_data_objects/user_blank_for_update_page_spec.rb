describe "UserBlankForUpdatePage" do
  let(:user) { double }
  let(:pipe) { double }
  subject(:user_blank_for_update_page) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    UserBlankForUpdatePage.new
  end

  def load_from_db_prepare_fakes(id)
    user.stub(:load_from_db).with id: id, attribute_group: :for_update, limit: 1 
  end

  def html_prepare_fakes
    user.stub(:loaded_to_hashes).and_return ["data1"]
    user.stub(:data_obj_name).and_return "Users"
    pipe.stub(:get).with(:html_for_update, data_by_type: {
      "Users" => ["data1"],
    }).and_return "HTML for update user page"
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

  it "gets pipe" do
    expect(user_blank_for_update_page.pipe).to eq pipe
  end

  context "loads user and makes update fields html" do
    it "in two steps" do
      load_from_db_prepare_fakes 12
      user_blank_for_update_page.load 12

      user.stub(:loaded_empty_result?).with(no_args).and_return false
      expect(user_blank_for_update_page.pipe_name_of_txt_if_empty_content).to eq false

      html_prepare_fakes
      expect(user_blank_for_update_page.html).to eq "HTML for update user page"
    end

    it "in one step" do
      load_from_db_prepare_fakes 12
      html_prepare_fakes
      expect(user_blank_for_update_page.load_and_get_html id: 12).to eq "HTML for update user page"
    end
  end

  it "displays msg if no user to load" do
    load_from_db_prepare_fakes 12
    user_blank_for_update_page.load 12

    user.stub(:loaded_empty_result?).with(no_args).and_return true
    expect(user_blank_for_update_page.pipe_name_of_txt_if_empty_content).to eq :no_user

    user_blank_for_update_page.stub(:html).and_return "No user."
    expect(user_blank_for_update_page.html).to eq "No user."
  end
end
