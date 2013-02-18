class Controller
  def initialize
    @pipe = Pipe.new
  end

  def action(action_name, data_object_name)
    user = User.new
    user.identify
    user.privileges = {
      visitor: {products: [[:published, :see]]},
      registered: {},
      seller: {products: [[:own, :all]], profile: [[:own, :all]]},
      admin: {products: [[:all, :all]], profile: [[:all, :all]]}
    }

    unless user.can action_name, data_object_name
      raise "User cannot access #{action_name} of #{data_object_name}"
    end

#   case data_object_name
#     when :product
#       case action_name
#         when :list
#       end
#   end

    if [:blank_for_create, :blank_for_update, :list, :details].include? action_name
      action_type = :page
    elsif [:update, :create, :delete].include? action_name
      action_type = :operation
    else
      raise "Unknown action #{action_name}"
    end

    action_class_name = Support.to_camel(data_object_name) + Support.to_camel(action_name) +
      Support.to_camel(action_type)
    if Kernel.const_defined? action_class_name
      action_class = Kernel.const_get action_class_name
    else
      raise "Undefined #{action_class_name}"
    end
    unless action_class.is_a? Class
      raise "Cannot find class #{action_class_name}"
    end

    action = action_class.new
    id_if_exists = @pipe.get :param_if_exists, :id
    if action_type == :page
      if id_if_exists
        action.load_and_get_html id_if_exists
      else
        action.load_and_get_html
      end
    else
      action.load_and_accomplish
    end
  end
end
