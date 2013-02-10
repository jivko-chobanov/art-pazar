module Main
  class Products < DataObjects
    def initialize(pipe = nil)
      @attribute_groups = AttributeGroups.new(
        list: [:name, :price],
        for_visitor: [:name, :price, :height],
        for_update: [:name, :category_id, :price],
        for_create: [:name, :category_id, :price],
      )
      super self.class, pipe
    end

    def type
      if loaded?
        :paintings
      else
        raise "Load first"
      end
    end
  end
end
