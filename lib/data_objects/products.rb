module Main
  class Products < DataObjects
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
      "Pr"
    end

    def id
      if loaded?
        if @table.get(data_obj_name).include? :id
          @table.get(data_obj_name)[:id]
        else
          raise "Loaded_data loaded, but does not have :id"
        end
      else
        raise "Loaded_data is not loaded"
      end
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
