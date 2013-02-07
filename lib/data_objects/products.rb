module Main
  class Products < DataObjects
    attr_reader :attribute_groups

    def initialize
      @attribute_groups = AttributeGroups.new(
        list: [:name, :price],
        for_visitor: [:name, :price, :height],
        for_update: [:name, :category_id, :price],
        for_create: [:name, :category_id, :price],
      )
      super self.class
    end
  end
end
