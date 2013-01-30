class AttributeGroups
  class Single
    attr_reader :name, :attributes

    def initialize(name, attributes)
      @name, @attributes = name, attributes
    end
  end

  def initialize(attributes_by_attribute_group_name = {})
    @attribute_groups = {}

    unless attributes_by_attribute_group_name.empty?
      attributes_by_attribute_group_name.each { |name, attributes| put name, attributes }
    end
  end

  def put(name, attributes)
    if @attribute_groups.include? name
      raise "#{name} already exists with value #{@attribute_groups[name].attributes}"
    else
      @attribute_groups[name] = Single.new name, attributes
    end
  end

  def get(name)
    if @attribute_groups.include? name
      @attribute_groups[name]
    else
      raise "#{name} does not exist"
    end
  end

  def attributes_of(name)
    get(name).attributes
  end
end
