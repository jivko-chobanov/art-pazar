class AttributeGroups
  def initialize(attributes_by_attribute_group_name = {})
    @attribute_groups = {}

    unless attributes_by_attribute_group_name.empty?
      attributes_by_attribute_group_name.each { |name, attributes| put name, attributes }
    end
  end

  def put(name, attributes)
    name_must_be_free_then(name) do
      @attribute_groups[name] = Single.new name, attributes
    end
  end

  def get(name)
    name_must_exist_then(name) do
      @attribute_groups[name]
    end
  end

  def attributes_of(name, options = {})
    if options.include? :suffix_to_be_added
      get(name).attributes_suffixed options[:suffix_to_be_added]
    else
      get(name).attributes
    end
  end

  private

  class Single
    attr_reader :name, :attributes

    def initialize(name, attributes)
      @name, @attributes = name, attributes
    end

    def attributes_suffixed(suffix)
      Support.add_suffix attributes, suffix
    end
  end

  def name_must_exist_then(name)
    if @attribute_groups.include? name
      yield
    else
      raise "#{name} does not exist"
    end
  end

  def name_must_be_free_then(name)
    if @attribute_groups.include? name
      raise "#{name} already exists with value #{@attribute_groups[name].attributes}"
    else
      yield
    end
  end
end
