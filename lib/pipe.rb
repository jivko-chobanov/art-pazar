class Pipe
  module Log
    attr_reader :logs

    def last_logged
      @logs.last
    end

    private

    def initialize_log
      @logs = []
    end

    def log(content)
      @logs << content
    end
  end

  class MissingNeedOrInputError < RuntimeError
  end

  include Log

  def initialize
    initialize_log
  end

  def put(data_obj_name, attributes)
    unless attributes.is_a? Hash
      raise "attributes should be Hash, not #{attributes.class.name}, value: #{attributes.to_s}"
    end

    if attributes.include? :id
      update data_obj_name, attributes[:id], attributes.select { |name, _| name != :id }
    end
  end

  def get(what, needs_and_input)
    unless needs_and_input.is_a? Hash
      raise "needs_and_input should be Hash, not #{needs_and_input.class.name}, value: #{needs_and_input.to_s}"
    end

    @needs_and_input = needs_and_input
    
    case what
      when :loaded_data_obj_content
        get_data
      when :html
        get_html
      when :html_for_update
        get_html_for_update
      when :html_for_create
        get_html_for_create
      when :txt
        case @needs_and_input[:txt]
          when :no_products_for_home_page
            "There are no products yet. Comming soon."
          else
            raise "text message for #{@needs_and_input[:txt]} not written"
        end
      else
        raise "cannot understand what is wanted by #{what.to_s}"
    end
  end

  private

  def update(data_obj_name, id, attributes)
    if defined? Rails
    else
      log "Id #{id} of #{data_obj_name} updates " +
        attributes.map { |name, value| "#{name} to #{value}" }.join(", ") + "."
      true
    end
  end

  def get_html_for_create
    check_needs_and_input __method__

    if defined? Rails
    else
      fake_html_for_create
    end
  end

  def get_html_for_update
    check_needs_and_input __method__

    if defined? Rails
    else
      fake_html_for_update
    end
  end

  def get_html
    check_needs_and_input __method__

    if defined? Rails
    else
      fake_html
    end
  end

  def fake_html_for_create
    if @needs_and_input[:data_by_type].empty?
      raise "Data for fields is empty"
    elsif @needs_and_input[:data_by_type].size > 1
      raise "Cannot load fields for more than one object"
    else
      "HTML for creating #{@needs_and_input[:data_by_type].keys.first} with fields: #{
        @needs_and_input[:data_by_type].first[1].first.join ", "
      }"
    end
  end

  def fake_html_for_update
    if @needs_and_input[:data_by_type].empty?
      raise "Loaded data is empty"
    elsif @needs_and_input[:data_by_type].size > 1
      raise "Cannot load fields for more than one object"
    else
      "HTML for updating #{@needs_and_input[:data_by_type].keys.first} fields: #{
        @needs_and_input[:data_by_type].first[1].first.map do |system_name_of_field, old_value|
          "#{system_name_of_field} was \"#{old_value}\""
        end.join ", "
      }"
    end
  end

  def fake_html
    if @needs_and_input[:data_by_type].empty?
      html = "HTML for empty data"
    else
      html = "HTML for #{@needs_and_input[:data_by_type].keys.join ", "}\n\n"

      @needs_and_input[:data_by_type].each do |data_obj_name, items|
        html << data_obj_name.to_s << ":\n"
        html << Support::as_table_string(items)
      end
    end

    html
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
        when "Products"
          @needs_and_input[:limit].times do |index|
            fake_data << fake_item(index)
          end
        else
          raise "does not know how to make fake data for #{@needs_and_input[:data_obj_name]}"
      end

    fake_data
  end

  def fake_item(i)
    {
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
    }.select do |name, value|
      @needs_and_input[:attributes].include? name
    end
  end

  def check_needs_and_input(for_method)
    case for_method
      when :get_data
        unless @needs_and_input.include? :limit
          raise MissingNeedOrInputError, "limit should be included into needs_and_input"
        end
      when :get_html, :get_html_for_update, :get_html_for_create
        unless @needs_and_input.include? :data_by_type
          raise MissingNeedOrInputError, "cannot make html without :data_by_type"
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
