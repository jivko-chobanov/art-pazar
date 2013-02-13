class Table
  include Enumerable

  def initialize
    @data_by_type ||= {}
  end

  def put(data_type, data)
    must_be_free_then(data_type) { @data_by_type[data_type] = data }
  end

  def replace(data_type, new_data)
    must_exist_then(data_type) { @data_by_type[data_type] = new_data }
  end

  def get(data_type)
    must_exist_then(data_type) { @data_by_type[data_type] }
  end

  def to_hash
    @data_by_type
  end

  def empty?
    Support.empty? @data_by_type
  end

  def types
    @data_by_type.keys
  end

  def each(&block)
    @data_by_type.each &block
  end

  def merge_to(data_type, other)
    replace data_type, get(data_type).merge(other)
  end

  private

  def must_be_free_then(data_type)
    if @data_by_type.include? data_type
      raise "#{data_type} does exist"
    else
      yield
    end
  end

  def must_exist_then(data_type)
    if @data_by_type.include? data_type
      yield
    else
      raise "#{data_type} does not exist in #{@data_by_type.keys}"
    end
  end
end
