class Pipe
  class MissingNeedOrInputError < RuntimeError
  end

  class << self
    def get(what, needs_and_input)
      unless needs_and_input.is_a? Hash
        raise "needs_and_input should be Hash, not #{needs_and_input.class.name}, value: #{needs_and_input.to_s}"
      end

      @needs_and_input = needs_and_input
      
      case what
        when :data
          get_data
        when :html
          get_html
        else
          raise "cannot understand what is wanted by #{what.to_s}"
      end
    end

    private

    def get_html
      check_needs_and_input __method__

      if defined? Rails
      else
        fake_html
      end
    end

    def fake_html
      html = "HTML for #{@needs_and_input[:data].keys.join ", "}"
    end

    def get_data
      check_needs_and_input __method__
      add_default_values_to_needs_and_input __method__

      if defined? Rails
      else
        fake_data
      end
    end

    def fake_data
        fake_data = []

        case @needs_and_input[:data_obj_name]
          when :product
            case @needs_and_input[:attribute_group]
              when :list
                @needs_and_input[:limit].times do |i|
                  fake_data << {
                    id: i + @needs_and_input[:offset],
                    name: "name value (#{i})",
                    price: 5.43 + i,
                    category_id: 12 + i % 2,
                    published: true,
                    sold: false,
                    width: 11 + i,
                    height: 12 + i,
                    depth: 13 + i,
                    short_description: "short_description value (#{i})",
                    info: "info value (#{i})",
                    created_at: "created_at value (#{i})",
                    updated_at: "updated_at value (#{i})",
                    product_type_id: 100 + i
                  }
                end
            end
          else
            raise "does not know how to make fake data for #{@needs_and_input[:data_obj_name]}"
        end

      fake_data
    end

    def check_needs_and_input(for_method)
      case for_method
        when :get_data
          unless @needs_and_input.include? :limit
            raise MissingNeedOrInputError, "limit should be included into needs_and_input"
          end
        when :get_html
          unless @needs_and_input.include? :data
            raise MissingNeedOrInputError, "cannot make html without :data"
          end
        else
          raise "undefined method #{for_method} in #{__method__}'s case"
      end
    end

    def add_default_values_to_needs_and_input(for_method)
      case for_method
        when :get_data
          unless @needs_and_input.include? :offset
            @needs_and_input[:offset] = 0;
          end
        else
          raise "undefined method #{for_method} in #{__method__}'s case"
      end
    end
  end
end
