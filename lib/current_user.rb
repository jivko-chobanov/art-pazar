class CurrentUser
  attr_reader :type

  def initialize(special_meanings, privileges)
    @pipe, @user, @special_meanings = Pipe.new, Main::Users.new, special_meanings
    identify_from_session
    @allowed_actions_by_data_object_name_and_condition = privileges[@type]
  end

  def get_filters_if_access(action, data_object_name)
    general_action = get_general_action action
    return false unless chance_to_access? general_action, data_object_name
    @allowed_actions_by_data_object_name_and_condition[data_object_name]
      .each do |condition, general_actions|
        if general_actions.include? general_action
          return case condition
            when :all
              {}
            when :own
              {userid: @id}
            when :published
              {published: true}
            else
              false
          end
        end
      end
  end

  def login
    username_and_password = @pipe.get :params, names: [:username, :password]
    user_hash = @pipe.get :runtime_table_hashes, {
      attribute_group: :for_login,
      username: username_and_password[:username],
      password: username_and_password[:password],
    }
    unless user_hash.empty?
      save_in_user user_hash
      @pipe.put :successful_authentication_in_session, {
        id: @id,
        type: @type,
      }
      true
    else
      false
    end
  end

  private

  def identify_from_session
    user_hash = @pipe.get :successful_authentication_in_session
    if user_hash
      save_in_user user_hash
      true
    else
      @type = :visitor
      false
    end
  end

  def save_in_user(user_hash)
    @user.set user_hash
    @type = @user.type
    @id = @user.id
  end

  def chance_to_access?(general_action, data_object_name)
    unless @allowed_actions_by_data_object_name_and_condition.include? data_object_name
      return false
    end
    @allowed_actions_by_data_object_name_and_condition[data_object_name]
      .any? { |condition, general_actions| general_actions.include? general_action }
  end

  def get_general_action(action)
    @special_meanings.each do |general_action, actions|
      return general_action if actions.include? action
    end
    action
  end
end
