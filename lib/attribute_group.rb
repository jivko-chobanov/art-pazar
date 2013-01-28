class AttributeGroup
  attr_reader :name, :attribute_names, :data_obj_class

  def initialize(name, attribute_names, data_obj_class)
    @name, @attribute_names, @data_obj_class = name, attribute_names, data_obj_class
    store
  end

  private

  def store
    @@attribute_groups ||= {}
    @@attribute_groups[@data_obj_class] ||= {}
    @@attribute_groups[@data_obj_class][@name] = self
  end

  class << self
    def get_attributes(name, data_obj_class)
      if defined? @@attribute_groups[data_obj_class][name]
        @@attribute_groups[data_obj_class][name].attribute_names
      else
        raise "cannot get attribute group #{name} of object #{data_obj_class}. All: #@@attribute_groups"
      end
    end
  end
end
