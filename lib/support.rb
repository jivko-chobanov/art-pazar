class Support
  class << self
    def add_suffix(array, suffix)
      array.map do |value|
        if value.is_a? Symbol
          (value.to_s + suffix).to_sym
        else
          value + suffix
        end
      end
    end

    def remove_suffix_from_keys(hash, suffix)
      hash.each_with_object({}) do |(suffixed_name, value), unsuffixed_hash|
        unsuffixed_hash[suffixed_name.to_s.gsub(/#{suffix}$/, '').to_sym] = value
      end
    end
  end

  module DataToTableString
    def as_table_string(ordered_rows_with_cells_described)
      ordered_rows_with_cells_described = column_names_to_head_row ordered_rows_with_cells_described
      ordered_rows = without_cells_description ordered_rows_with_cells_described

      rows_of_values_to_table ordered_rows
    end

    private

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
      rows_of_values.map { |row| row[column_id].to_s.length }.max
    end

    def column_names_to_head_row(rows_by_ordering_index_where_row_is_hash_of_column_name_and_cell_value)
      rows = rows_by_ordering_index_where_row_is_hash_of_column_name_and_cell_value
      column_names = Hash[rows.first].keys

      rows.unshift column_names.zip(column_names.map &:upcase)
      rows
    end
  end

  extend DataToTableString

  class << self
    EMPTY_VALUES = [0, "", [], {}, nil, 0.0, false]

    def empty?(x)
      EMPTY_VALUES.include? x or ( x.is_a? Hash and x.all? { |_, value| Support.empty? value } )
    end
  end
end
