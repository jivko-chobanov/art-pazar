class DataObjects
  def initialize(child_class)
    @loaded_data = LoadedData.new
    @tried_to_load = false
    @pipe = Pipe.new
    @child_class = child_class
  end

  def load(needs)
    @tried_to_load = true
    needs[:data_obj_name] = data_obj_name
    needs[:attributes] = attributes_of needs[:attribute_group]
    needs.delete :attribute_group
    @loaded_data.put data_obj_name, @pipe.get(:loaded_data_obj_content, needs)
  end

  def html
    if initialized_only?
      raise "Cannot generate HTML without data to be loaded first."
    else
      @pipe.get :html, data_by_type: @loaded_data.to_hash
    end
  end

  def input_fields_html
    "Fill in fields: #{attributes_of(:fields_for_create_or_update).join ", "}"
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

  def data_obj_name
    self.class.name.split("::").last
  end

  def create(attributes)
    if attributes.include? :id
      raise "Cannot create with an id"
    end

    unless (attributes_of(:fields_for_create_or_update) - attributes.keys).empty?
      raise "Attributes must also contain #{
        (attributes_of(:fields_for_create_or_update) - attributes.keys).join ", "}."
    end

    put attributes
  end

  def update(attributes)
    put attributes
  end

  def attributes_of(group_name)
    @attribute_groups.attributes_of group_name
  end

  private

  def put(attributes)
    @pipe.put data_obj_name, attributes
  end
end
