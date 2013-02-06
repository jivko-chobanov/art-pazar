module Main
  class Products < DataObjects
    attr_reader :attribute_groups

    def initialize
      @attribute_groups = AttributeGroups.new(
        list: [:name, :price],
        fields_for_create_or_update: [:name, :category_id, :price]
      )
      super self.class
    end
  end
end
