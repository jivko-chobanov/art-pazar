class LoadedData
  include Enumerable

  def initialize
    @data_by_data_type ||= {}
  end

  def put(data_type, data)
    @data_by_data_type[data_type] = data
  end

  def get(data_type)
    if @data_by_data_type.include? data_type
      @data_by_data_type[data_type]
    else
      raise "#{data_type} does not exist in #{@data_by_data_type.keys}"
    end
  end

  def empty?
    Support.empty? @data_by_data_type
  end

  def types
    @data_by_data_type.keys
  end

  def each(&block)
    @data_by_data_type.each &block
  end
end
