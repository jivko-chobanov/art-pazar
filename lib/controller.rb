class Controller
  def initialize
    @pipe = Pipe.new
  end

  def action(action_name, data_object_name, additional_hash_args_for_action = {})
    user = CurrentUser.new({
        see: [:list, :details],
        create: [:create, :blank_for_create],
        update: [:update, :blank_for_update],
      }, {
        visitor: {product: {published: [:see]}},
        registered: {
          user: {own: [:see, :create, :update, :delete]},
        },
        seller: {
          product: {own: [:see, :create, :update, :delete]},
        },
        admin: {
          product: {all: [:see, :create, :update, :delete, :publish]},
          user: {all: [:see, :create, :update, :delete]},
        },
      },
      [:visitor, :registered, :seller, :admin]
    )

    filters = filters_or_raise_no_permissions(user, action_name, data_object_name)
    action_type = action_type_or_raise_undefined(action_name)
    action_class = action_class_or_raise_undefined(action_type, action_name, data_object_name)

    @action = action_class.new
    id_if_exists = @pipe.get :param_if_exists, param_name: :id

    args_for_action = {}
    args_for_action[:id] = id_if_exists if id_if_exists
    args_for_action.merge! filters
    args_for_action.merge! additional_hash_args_for_action
    if action_type == :page
      @action.public_send :load_and_get_html, args_for_action
    else
      @action.public_send :load_and_accomplish, args_for_action
    end
  end

  def logs
    must_have_done_action_then { @action.pipe.logs }
  end

  private

  def must_have_done_action_then
    if @action.nil?
      raise "Do the action first"
    else
      yield
    end
  end

  def filters_or_raise_no_permissions(user, action_name, data_object_name)
    user.get_filters_if_access(action_name, data_object_name) or
      raise "Do not have permission to #{action_name} #{data_object_name}"
  end

  def action_type_or_raise_undefined(action_name)
    if [:blank_for_create, :blank_for_update, :list, :details].include? action_name
      :page
    elsif [:update, :create, :delete].include? action_name
      :operation
    else
      raise "Unknown action #{action_name}"
    end
  end

  def action_class_or_raise_undefined(action_type, action_name, data_object_name)
    action_class_name = Support.to_camel_string(data_object_name) + Support.to_camel_string(action_name) +
      Support.to_camel_string(action_type)
    if Kernel.const_defined? action_class_name
      action_class = Kernel.const_get action_class_name
    else
      raise "Undefined #{action_class_name}"
    end
    unless action_class.is_a? Class
      raise "Cannot find class #{action_class_name}"
    end
    action_class
  end
end
