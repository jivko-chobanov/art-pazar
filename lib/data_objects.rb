class DataObjects
  def initialize(child_class, child_class_unique_abbreviation, pipe = nil)
    @loaded_data = LoadedData.new
    @is_loaded = false
    pipe ? @pipe = pipe : @pipe = Pipe.new
    @child_class, @child_class_unique_abbreviation = child_class, child_class_unique_abbreviation
  end

  def load_from_params(needs)
    unless needs.include? :attribute_group
      raise "Load from params must have in its needs :attribute_group"
    end

    @is_loaded = true

    suffix = "_" + @child_class_unique_abbreviation

    needs[:names] = Support.add_suffix attributes_of(needs[:attribute_group]), suffix
    needs.delete :attribute_group

    @loaded_data.put data_obj_name, Support.remove_suffix_from_keys(@pipe.get(:params, needs), suffix)
  end

  def load_from_db(needs)
    unless needs.include? :attribute_group
      raise "Load from db must have in its needs :attribute_group"
    end

    @is_loaded = true

    needs[:attributes] = attributes_of needs[:attribute_group]
    needs.delete :attribute_group

    @loaded_data.put data_obj_name, @pipe.get(:loaded_data_obj_content, needs)
  end

  def loaded_data_hash
    if_loaded_then do
      @loaded_data.to_hash
    end
  end

  def html
    if_loaded_then do
      @pipe.get :html, data_by_type: @loaded_data.to_hash
    end
  end

  def html_for_update
    if_loaded_then do
      @pipe.get :html_for_update, data_by_type: @loaded_data.to_hash
    end
  end

  def loaded_data_hash_for_update
    loaded_data_hash
  end

  def loaded_data_hash_for_create
    {data_obj_name => [attributes_of(:for_create)]}
  end

  def html_for_create
    @pipe.get :html_for_create, data_by_type: loaded_data_hash_for_create
  end

  def loaded?
    @is_loaded
  end

  def loaded_empty_result?
    if loaded?
      @loaded_data.empty?
    else
      raise "Not tried to load yet."
    end
  end

  def data_obj_name
    self.class.name.split("::").last
  end

  def create(attributes = nil)
    attributes = prepare_and_check_attributes_for_create attributes
    success = put attributes
    @loaded_data.merge_to(data_obj_name, {id:
      @pipe.get(:last_created_id, data_obj_name: data_obj_name)
    })
    success
  end

  def load_and_create
    load_from_params attribute_group: :for_create
    create
  end

  def update(attributes = nil)
    attributes = prepare_and_check_attributes_for_update attributes
    put attributes
  end

  def load_and_update
    load_from_params attribute_group: :for_update
    update
  end

  def attributes_of(group_name, options = {})
    @attribute_groups.attributes_of group_name, options
  end

  private

  def prepare_and_check_attributes_for_update(attributes)
    if attributes.nil? then attributes = @loaded_data.get data_obj_name end
    unless attributes.include? :id
      raise "Cannot update without an id"
    end
    attributes
  end

  def prepare_and_check_attributes_for_create(attributes)
    if attributes.nil? then attributes = @loaded_data.get data_obj_name end
    if attributes.include? :id
      raise "Cannot create with an id"
    end

    unless (attributes_of(:for_create) - attributes.keys).empty?
      raise "Attributes #{attributes.keys.join ", "} must also contain #{
        (attributes_of(:for_create) - attributes.keys).join ", "}."
    end
    attributes
  end

  def put(attributes)
    @pipe.put data_obj_name, attributes
  end

  def if_loaded_then
    if loaded?
      yield
    else
      raise "Cannot generate HTML without data to be loaded first."
    end
  end
end
