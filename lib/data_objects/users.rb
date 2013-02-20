module Main
  class Users < DataObjects
    def initialize(pipe = nil)
      @attribute_groups = AttributeGroups.new(
        list: [:name, :price],
        for_visitor: [:name, :price, :height],
        for_update: [:id, :name, :category_id, :price],
        for_create: [:name, :category_id, :price],
      )
      super pipe
    end

    def class_abbreviation
      "U"
    end
  end
end
