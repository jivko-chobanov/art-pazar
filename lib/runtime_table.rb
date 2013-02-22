class RuntimeTable
  class Row
    def initialize(values_by_column_name = {})
      @cells_by_column = {}
      self << values_by_column_name
    end

    def <<(values_by_column_name)
      @cells_by_column = @cells_by_column.merge values_by_column_name
    end

    def column_names
      @cells_by_column.keys
    end

    def to_hash
      @cells_by_column
    end

    def method_missing(name, *args, &block)
      if @cells_by_column.include? name
        @cells_by_column[name]
      else
        super
      end
    end

    def respond_to_missing?(name, include_private)
      if @cells_by_column.include? name then true else super end
    end
  end

  include Enumerable

  def initialize(array_of_values_by_column_name = [])
    @rows = []
    self << array_of_values_by_column_name
  end

  def to_hashes
    @rows.map(&:to_hash)
  end

  def <<(array_of_values_by_column_name)
    must_be_compatible_then(array_of_values_by_column_name) do
      @rows = @rows + to_rows(array_of_values_by_column_name)
    end
  end

  def empty?
    @rows.empty?
  end

  def column_names
    must_have_row_then { @rows.first.column_names }
  end

  def each(&block)
    @rows.each &block
  end

  def row
    if rows_count == 0 then @rows = [Row.new] end

    if rows_count == 1
      @rows.first
    else
      raise "The number of rows is #{rows_count}, not 1"
    end
  end

  private

  def must_be_compatible_then(array_of_values_by_column_name)
    if compatible?(array_of_values_by_column_name)
      yield
    else
      raise "Array of values by column name is not compatible to the contents of the runtime table.\n" <<
      "Array: #{array_of_values_by_column_name} ----- Table: #{to_hashes}"
    end
  end

  def compatible?(array_of_values_by_column_name)
    return true if empty?

    array_of_values_by_column_name.all? do |values_by_column_name|
      column_names.sort == values_by_column_name.keys.sort
    end
  end

  def rows_count
    @rows.count
  end

  def to_rows(array_of_values_by_column_name)
    array_of_values_by_column_name.map do |values_by_column_name|
      Row.new values_by_column_name
    end
  end

  def must_have_row_then
    if empty?
      raise "The table is empty"
    else
      yield
    end
  end
end
