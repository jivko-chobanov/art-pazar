describe "UserBlankForCreatePage" do
  let(:user) { double }
  let(:pipe) { double }
  subject(:user_blank_for_create_page) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    UserBlankForCreatePage.new
  end

  def load_from_args_prepare_fakes
  end

  def html_prepare_fakes
    user.stub(:attributes_of).and_return ["attribute names 1"]
    user.stub(:data_obj_name).and_return "Users"
    pipe.stub(:get).with(:html_for_create, data_by_type: {
      "Users" => ["attribute names 1"],
    }).and_return "HTML for create user page"
  end

  before do
    stub_const "Page", Class.new
    stub_const "Main", Module.new
    stub_const "Main::Users", Class.new
    stub_const "Pipe", Class.new

    Main::Users.stub(:new).and_return user
    Pipe.stub(:new) { pipe }
    Page.send(:define_method, :load) { |&block| block.call if block_given? }
    Page.send(:define_method, :html) { |&block| block.call }
  end

  it "gets pipe" do
    expect(user_blank_for_create_page.pipe).to eq pipe
  end

  context "loads user and makes create fields html" do
    it "in two steps" do
      load_from_args_prepare_fakes
      user_blank_for_create_page.load

      expect(user_blank_for_create_page.pipe_name_of_txt_if_empty_content).to eq false

      html_prepare_fakes
      expect(user_blank_for_create_page.html).to eq "HTML for create user page"
    end

    it "in one step" do
      load_from_args_prepare_fakes
      html_prepare_fakes
      expect(user_blank_for_create_page.load_and_get_html).to eq "HTML for create user page"
    end
  end
end
