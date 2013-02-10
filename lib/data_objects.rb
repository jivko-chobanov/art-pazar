class DataObjects
  def initialize(child_class, pipe = nil)
    @loaded_data = LoadedData.new
    @is_loaded = false
    pipe ? @pipe = pipe : @pipe = Pipe.new
    @child_class = child_class
  end

  def load_from_params(needs)
    needs[:pipe_gets_what] = :params
    load_from_pipe needs
  end

  def load_from_db(needs)
    needs[:pipe_gets_what] = :loaded_data_obj_content
    load_from_pipe needs
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

  def create(attributes)
    if attributes.include? :id
      raise "Cannot create with an id"
    end

    unless (attributes_of(:for_create) - attributes.keys).empty?
      raise "Attributes #{attributes.keys.join ", "} must also contain #{
        (attributes_of(:for_create) - attributes.keys).join ", "}."
    end

    put attributes
  end

  def update(attributes)
    unless attributes.include? :id
      raise "Cannot update without an id"
    end

    put attributes
  end

  def attributes_of(group_name, options = {})
    @attribute_groups.attributes_of group_name, options
  end

  private

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

  def load_from_pipe(needs)
    check_needs(needs)

    @is_loaded = true

    pipe_gets_what = needs[:pipe_gets_what]
    needs.delete :pipe_gets_what

    needs[:attributes] = attributes_of needs[:attribute_group]
    needs.delete :attribute_group

    @loaded_data.put data_obj_name, @pipe.get(pipe_gets_what, needs)
  end

  def check_needs(needs)
    unless needs.include? :attribute_group
      raise "Load must have in its needs :attribute_group"
    end
  end
end
