module Main
  class ProductSpecifications < DataObjects
    class Type
      def initialize(product_type)
        @data = {
          paintings: {
            attribute_groups_definitions_using_instance_names: {
              list: [:artist, :year],
              for_visitor: [:artist, :year, :paint, :frames],
            },
            attribute_names_by_instance_attribute_name: {
              year: :smallint_1,
              artist: :string_1,
              paint: :string_2,
              frames: :string_3
            }
          }
        }

        unless possible_type_names.include? product_type
          raise "Undefined product type."
        end

        @product_type = product_type 
        @type_data = @data[@product_type]
      end

      def possible_type_names
        @data.keys
      end

      def attribute_groups_definitions
        definitions = {}
        @type_data[:attribute_groups_definitions_using_instance_names]
          .each_with_object(definitions) do |(group_name, instance_attribute_names)|
            definitions[group_name] = instance_attribute_names.map! do |instance_name|
              instance_attribute_name_to_general instance_name
            end
          end
        definitions
      end

      def instance_attribute_name_to_general(instance_name)
        @type_data[:attribute_names_by_instance_attribute_name][instance_name]
      end

      def instance_attribute_names
        @type_data[:attribute_names_by_instance_attribute_name].keys
      end
    end

    def type=(product_type)
      @type = Type.new product_type
      @attribute_groups = AttributeGroups.new @type.attribute_groups_definitions
    end

    def initialize
      super self.class
    end

    def specification_names
      if type_set?
        @type.instance_attribute_names
      end
    end

    def attributes_of attribute_group
      if type_set?
        super attribute_group
      end
    end

    private

    def type_set?
      if @type.nil?
        raise "Set #type= first"
      end
      true
    end
  end
end
