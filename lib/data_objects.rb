class DataObjects
  def initialize(pipe = nil)
    @runtime_table = RuntimeTable.new
    @is_loaded = false
    pipe ? @pipe = pipe : @pipe = Pipe.new
  end

  def load_from_params(needs)
    prepare_loading(needs)

    suffix = "_" + class_abbreviation

    needs[:names] = attributes_of needs[:attribute_group], suffix_to_be_added: suffix
    needs.delete :attribute_group

    put_to_runtime_table Support.remove_suffix_from_keys(@pipe.get(:params, needs), suffix)
  end

  def load_from_db(needs)
    prepare_loading(needs)

    needs[:attributes] = attributes_of needs[:attribute_group]
    needs.delete :attribute_group

    needs[:data_obj_name] = data_obj_name

    put_to_runtime_table @pipe.get(:runtime_table_hashes, needs)
  end

  def runtime_table_hashes
    must_be_loaded_then do
      @runtime_table.as_hashes
    end
  end

  def html
    must_be_loaded_then do
      @pipe.get :html, data_by_type: {data_obj_name => @runtime_table.as_hashes}
    end
  end

  def html_for_update
    must_be_loaded_then do
      @pipe.get :html_for_update, data_by_type: @runtime_table.as_hashes
    end
  end

  def html_for_create
    @pipe.get :html_for_create, data_by_type: {data_obj_name => [attributes_of(:for_create)]}
  end

  def loaded?
    @is_loaded
  end

  def loaded_empty_result?
    if loaded?
      @runtime_table.empty?
    else
      raise "Not tried to load yet."
    end
  end

  def data_obj_name
    self.class.name.split("::").last
  end

  def create(attributes = nil)
    attributes = prepare_and_check_attributes_for_create attributes
    success = put_to_pipe attributes
    @runtime_table.row << {id: @pipe.get(:last_created_id, data_obj_name: data_obj_name)}
    success
  end

  def load_and_create
    load_from_params attribute_group: :for_create
    create
  end

  def update(attributes = nil)
    attributes = prepare_and_check_attributes_for_update attributes
    put_to_pipe attributes
  end

  def load_and_update
    load_from_params attribute_group: :for_update
    update
  end

  def attributes_of(group_name, options = {})
    @attribute_groups.attributes_of group_name, options
  end

  private

  def prepare_loading(needs)
    unless needs.include? :attribute_group
      raise "Loading must have in its needs :attribute_group"
    end

    @is_loaded = true
  end

  def prepare_and_check_attributes_for_update(attributes)
    if attributes.nil? then attributes = @runtime_table.row.as_hash end
    unless attributes.include? :id
      raise "Cannot update without an id"
    end
    attributes
  end

  def prepare_and_check_attributes_for_create(attributes)
    if attributes.nil? then attributes = @runtime_table.row.as_hash end
    if attributes.include? :id
      raise "Cannot create with an id"
    end

    unless (attributes_of(:for_create) - attributes.keys).empty?
      raise "Attributes #{attributes.keys.join ", "} must also contain #{
        (attributes_of(:for_create) - attributes.keys).join ", "}."
    end
    attributes
  end

  def put_to_pipe(attributes)
    @pipe.put data_obj_name, attributes
  end

  def put_to_runtime_table(rows_or_hash_to_the_row)
    if rows_or_hash_to_the_row.is_a? Array
      @runtime_table << rows_or_hash_to_the_row
    else
      @runtime_table.row << rows_or_hash_to_the_row
    end
  end

  def must_be_loaded_then
    if loaded?
      yield
    else
      raise "Cannot generate HTML without data to be loaded first."
    end
  end
end
