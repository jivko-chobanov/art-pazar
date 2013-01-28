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
      html = "HTML for #{@needs_and_input[:data].keys.join ", "}\n\n"

      @needs_and_input[:data].each do |data_obj_name, items|
        html << data_obj_name.to_s << ":\n"
        html << as_table_string(items)
      end
      html
    end

    def as_table_string(ordered_rows_with_cells_described)
      ordered_rows_with_cells_described = column_names_to_head_row ordered_rows_with_cells_described
      ordered_rows = without_cells_description ordered_rows_with_cells_described

      rows_of_values_to_table ordered_rows
    end

    def without_cells_description(rows_with_cells_by_column_name)
      rows_with_cells_by_column_name.map { |cells_by_column_name| Hash[cells_by_column_name].values }
    end

    def rows_of_values_to_table(rows_of_values)
      table_string = rows_of_values.inject("") do |table, cells|
        column_id = 0
        row_str = cells.inject("") do |row, value|
          row << value.to_s.ljust(2 + max_length_of_column(column_id, rows_of_values))
          column_id = column_id + 1
          row
        end
        table << row_str.strip << "\n"
      end
      table_string
    end

    def max_length_of_column(column_id, rows_of_values)
      max_length = 0
      rows_of_values.each do |row|
        max_length = row[column_id].to_s.length if row[column_id].to_s.length > max_length
      end
      max_length
    end

    def column_names_to_head_row(rows_by_ordering_index_where_row_is_hash_of_column_name_and_cell_value)
      rows = rows_by_ordering_index_where_row_is_hash_of_column_name_and_cell_value
      column_names = Hash[rows.first].keys

      rows.unshift column_names.zip(column_names)
      rows
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

        unless @needs_and_input[:data_obj_class].respond_to? :name
          raise "data object class should be class const, not #@needs_and_input[:data_obj_class]"
        end

        case @needs_and_input[:data_obj_class].name
          when Main::Product.name
            @needs_and_input[:limit].times do |index|
              fake_data << fake_item(index)
            end
          else
            raise "does not know how to make fake data for #{@needs_and_input[:data_obj_class]}"
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
        @needs_and_input[:data_obj_class]
          .get_attributes(@needs_and_input[:attribute_group])
          .include? name
      end
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
