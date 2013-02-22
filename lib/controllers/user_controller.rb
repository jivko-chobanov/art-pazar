class UserController
  attr_reader :type

  def initialize(special_meanings, privileges, user_type_inheritance_inherit_previous)
    @pipe, @user, @special_meanings = Pipe.new, Main::Users.new, special_meanings
    identify_from_session

    @allowed_actions_by_data_object_name_and_condition = {}
    user_type_inheritance_inherit_previous.each do |user_type|
      privileges[user_type].each do |data_object_name, actions_by_condition|
        @allowed_actions_by_data_object_name_and_condition[data_object_name] ||= {}
        @allowed_actions_by_data_object_name_and_condition[data_object_name].
          merge! actions_by_condition
      end
      break if user_type == @type
    end
  end

  def get_filters_if_access(action, data_object_name)
    general_action = get_general_action action
    return false unless chance_to_access? general_action, data_object_name

    conditions_by_condition_name = {}
    @allowed_actions_by_data_object_name_and_condition[data_object_name]
      .each do |condition_name, general_actions|
        if general_actions.include? general_action
          conditions_by_condition_name[condition_name] = case condition_name
            when :all
              {}
            when :buyer_own
              {buyer_id: @id}
            when :seller_own
              {seller_id: @id}
            when :buyer_own_while_ordering
              {buyer_id: @id, status: :ordering}
            when :own
              if data_object_name == :user
                {id: @id}
              else
                {user_id: @id}
              end
            when :published
              {published: true}
            else
              false
          end
        end
      end

    if conditions_by_condition_name.include? :all
      conditions_by_condition_name[:all]
    elsif conditions_by_condition_name.one? { |name, condition| condition }
      conditions_by_condition_name.each_value { |condition| return condition if condition }
    elsif conditions_by_condition_name.none? { |name, condition| condition }
      false
    else
      or_conditions = []
      conditions_by_condition_name.each_value do |condition|
        or_conditions << condition if condition
      end
      or_conditions
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
