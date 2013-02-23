require(__FILE__.split('art_pazar/').first << '/art_pazar/lib/lib_loader.rb')

describe "In integration RequestController works with Users" do
  let(:controller) { RequestController.new }

  def user_of_type(type, id = 14, id_from_params = 14)
    Pipe::Fake.should_receive(:get_from_session).and_return id: id, type: type
    Pipe::Fake.should_receive(:param_if_exists).with(:id).and_return id_from_params
  end

  context "registered" do
    it "gets profile page html" do
      user_of_type :registered
      expect(controller.action :details, :user).to eq(
"HTML for Users

Users:
NAME            SURNAME            TYPE
name value (0)  surname value (0)  type value (0)
")
    end

    it "gets profile create page html" do
      user_of_type :registered
      expect(controller.action :blank_for_create, :user).to eq(
"HTML for creating Users with fields:

Users:
name, surname, username, password
")
    end

    it "creates profile" do
      user_of_type :registered
      expect(controller.action :create, :user).to eq true
      expect(controller.logs).to eq(
        ["Got params: name_U = name_U param val, surname_U = surname_U param val, " <<
           "username_U = username_U param val, password_U = password_U param val",
        "Users creates name to name_U param val, surname to surname_U param val, " <<
           "username to username_U param val, password to password_U param val."]
      )
    end

    it "gets profile update page html" do
      user_of_type :registered
      expect(controller.action :blank_for_update, :user).to eq(
%q{HTML for updating Users fields:

Users:
id was "0", name was "name value (0)", surname was "surname value (0)"
})
    end

    it "updates profile" do
      user_of_type :registered
      expect(controller.action :update, :user).to eq true
      expect(controller.logs).to eq(
        ["Got params: id_U = id_U param val, name_U = name_U param val, " <<
          "surname_U = surname_U param val",
        "Id id_U param val of Users updates name to name_U param val, " <<
          "surname to surname_U param val."]
      )
    end

    it "deletes profile" do
      user_of_type :registered
      expect(controller.action :delete, :user).to eq true
      expect(controller.logs).to eq(
        ["Users with id = 14 is now deleted."]
      )
    end
  end

  context "seller" do
  end

  context "admin" do
    it "sees html for users" do
      user_of_type :admin
      expect(controller.action :list, :user).to eq "HTML for Users

Users:
NAME            SURNAME
name value (0)  surname value (0)
name value (1)  surname value (1)
name value (2)  surname value (2)
name value (3)  surname value (3)
name value (4)  surname value (4)
name value (5)  surname value (5)
name value (6)  surname value (6)
name value (7)  surname value (7)
name value (8)  surname value (8)
name value (9)  surname value (9)
"
    end
  end
end
