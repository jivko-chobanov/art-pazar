module Main
  class Products
    attr_reader :attribute_groups

    def initialize
      @attribute_groups = AttributeGroups.new(
        list: [:name, :price],
        fields_for_put_or_update: [:name, :category_id, :price]
      )
      @loaded_data = LoadedData.new
      @tried_to_load = false
    end

    def get(needs)
      @tried_to_load = true
      needs[:data_obj_class] = Main::Products
      @loaded_data.put :products, Pipe.get(:loaded_data_obj, needs)
    end

    def html
      if initialized_only?
        raise "Cannot generate HTML without data to be loaded first."
      else
        Pipe.get :html, loaded_data_obj: @loaded_data
      end
    end

    def initialized_only?
      not( @tried_to_load )
    end

    def loaded_empty_result?
      if initialized_only?
        raise "Not tried to load yet."
      else
        @loaded_data.empty?
      end
    end

    def self.attributes_of(group_name)
      new.attribute_groups.attributes_of group_name
    end
  end
end
