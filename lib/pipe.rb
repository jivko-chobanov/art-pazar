class Pipe
  class Fake
  end

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

  include Log

  def initialize
    initialize_log
  end

  def delete(data_obj_name, attributes)
    Support.must_be_hash attributes, "attributes"

    if defined? Rails
    else
      log "#{data_obj_name} with #{attributes.keys.first} = #{attributes.values.first} is now deleted."
      true
    end
  end

  def put(data_obj_name, attributes)
    Support.must_be_hash attributes, "attributes"

    if attributes.include? :id
      update data_obj_name, attributes[:id], attributes.select { |name, _| name != :id }
    else
      create data_obj_name, attributes
    end
  end

  def get(what, needs_and_input = {})
    Support.must_be_hash needs_and_input, "needs_and_input"
    @needs_and_input = needs_and_input

    case what
      when :runtime_table_hashes
        get_data
      when :html
        get_html
      when :html_for_update
        get_html_for_update
      when :html_for_create
        get_html_for_create
      when :last_created_id
        if needs_and_input.include? :data_obj_name
          24
        else
          raise "needs_and_input does not include :data_obj_name"
        end
      when :param_if_exists
        Fake.param_if_exists @needs_and_input[:param_name]
      when :successful_authentication_in_session
        Fake.get_from_session
      when :params
        values_by_name = {}
        @needs_and_input[:names].inject(values_by_name) do |values_by_name, name|
          if values_by_name.include? name then raise "You have 2 params with the same name" end
          values_by_name.merge! name => "#{name} param val"
        end
        log "Got params: " << values_by_name.map { |name, value| "#{name} = #{value}" }.join(", ")
        values_by_name
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

  def create(data_obj_name, attributes)
    if defined? Rails
    else
      log "#{data_obj_name} creates " <<
        attributes.map { |name, value| "#{name} to #{value}" }.join(", ") + "."
      true
    end
  end

  def update(data_obj_name, id, attributes)
    if defined? Rails
    else
      log "Id #{id} of #{data_obj_name} updates " <<
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
    html = ""
    if @needs_and_input[:data_by_type].empty?
      raise "Data for fields is empty"
    else
      html = "HTML for creating #{@needs_and_input[:data_by_type].keys.join ", "} with fields:\n\n"

      @needs_and_input[:data_by_type].each do |data_obj_name, item_of_system_names_of_fields|
        html << data_obj_name.to_s << ":\n"
        html << item_of_system_names_of_fields.join(", ") << "\n"
      end
    end
    html
  end

  def fake_html_for_update
    html = ""
    if @needs_and_input[:data_by_type].empty?
      raise "Loaded data is empty"
    else
      html = "HTML for updating #{@needs_and_input[:data_by_type].keys.join ", "} fields:\n\n"

      @needs_and_input[:data_by_type].each do |data_obj_name, items|
        html << data_obj_name.to_s << ":\n"
        items.each do |item|
          html << item.map do |system_name, old_value|
            "#{system_name} was \"#{old_value}\""
          end.join(", ") << "\n"
        end
      end
    end
    html
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

      fake_item_method = case @needs_and_input[:data_obj_name]
        when "Products"
          ->(index) { fake_product index }
        when "ProductSpecifications"
          ->(index) { fake_product_specifications index }
        when "Users"
          ->(index) { fake_user index }
        when "Carts"
          ->(index) { fake_cart index }
        else
          raise "does not know how to make fake data for #{@needs_and_input[:data_obj_name]}"
      end

      @needs_and_input[:limit].times do |index|
        fake_data << fake_item_method.(index)
      end

    fake_data
  end

  def get_wated_attributes(fake_item)
    fake_item.select do |name, value|
      @needs_and_input[:attributes].include? name
    end
  end

  def fake_product_specifications(i)
    get_wated_attributes({
      id: i + @needs_and_input[:offset],
      tinyint_1: i,
      smallint_1: i,
      smallint_2: i,
      int_1: i,
      string_1: "value1 (#{i})",
      string_2: "value2 (#{i})",
      string_3: "value3 (#{i})",
      string_4: "value4 (#{i})",
      string_5: "value5 (#{i})",
      string_6: "value6 (#{i})",
      string_7: "value7 (#{i})",
      string_8: "value8 (#{i})",
      string_9: "value9 (#{i})",
      float_1: i + 0.5,
      datetime_1: "datetime1 (#{i})",
      datetime_2: "datetime1 (#{i})",
      boolean_1: true,
      boolean_2: false,
      boolean_3: true,
      boolean_4: false,
      boolean_5: true,
      created_at: "created at",
      updated_at: "updated at",
      product_type_id: i + 100,
      product_id: i + 1000,
    })
  end

  def fake_product(i)
    get_wated_attributes({
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
    })
  end

  def fake_user(i)
    get_wated_attributes({
      id: i + @needs_and_input[:offset],
      name: "name value (#{i})",
      surname: "surname value (#{i})",
      type: "type value (#{i})",
      created_at: "created_at value (#{i})",
      updated_at: "updated_at value (#{i})",
      product_type_id: 100 + i
    })
  end

  def fake_cart(i)
    get_wated_attributes({
      id: i + @needs_and_input[:offset],
      buyer_id: i + @needs_and_input[:offset],
      seller_id: i + @needs_and_input[:offset],
      status: "status value (#{i})",
      created_at: "created_at value (#{i})",
      updated_at: "updated_at value (#{i})",
      product_type_id: 100 + i
    })
  end

  def check_needs_and_input(for_method)
    case for_method
      when :get_data
        unless @needs_and_input.include? :limit
          raise "limit should be included into needs_and_input"
        end
      when :get_html, :get_html_for_update, :get_html_for_create
        unless @needs_and_input.include? :data_by_type
          raise "cannot make html without :data_by_type"
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
