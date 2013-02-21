class DataObjects
  module Actions
    def create(attributes = nil)
      attributes = get_or_check_attributes_for_create attributes
      success = put_to_pipe attributes
      @runtime_table.row << {id: @pipe.get(:last_created_id, data_obj_name: data_obj_name)}
      success
    end

    def load_and_create
      load_from_params attribute_group: :for_create
      create
    end

    def update(attributes = nil)
      attributes = get_or_check_attributes_for_update attributes
      put_to_pipe attributes
    end

    def load_and_update
      load_from_params attribute_group: :for_update
      update
    end

    def delete(id_or_hash = nil)
      attribute_by_name = id_or_hash_or_nil_to_hash_for_delete id_or_hash
      @pipe.delete data_obj_name, attribute_by_name
    end

    def load_and_delete
      load_from_params attribute_group: :id
      delete
    end

    private

    def id_or_hash_or_nil_to_hash_for_delete(id_or_hash_or_nil)
      attribute_by_name = {}
      if id_or_hash_or_nil.nil? and @runtime_table.row.respond_to? :id
        attribute_by_name[:id] = @runtime_table.row.id
      elsif id_or_hash_or_nil.is_a? Fixnum
        attribute_by_name[:id] = id_or_hash_or_nil
      elsif id_or_hash_or_nil.is_a? Hash and id_or_hash_or_nil.size == 1
        attribute_by_name = id_or_hash_or_nil
      else
        raise "Cannot delete using #{id_or_hash_or_nil}"
      end
      attribute_by_name
    end

    def get_or_check_attributes_for_update(attributes)
      if attributes.nil? then attributes = @runtime_table.row.as_hash end
      unless attributes.include? :id
        raise "Cannot update without an id"
      end
      attributes
    end

    def get_or_check_attributes_for_create(attributes)
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
  end

  module Load
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

    def loaded_as_hashes
      must_be_loaded_then do
        @runtime_table.as_hashes
      end
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

    private

    def prepare_loading(needs)
      unless needs.include? :attribute_group
        raise "Loading must have in its needs :attribute_group"
      end

      @is_loaded = true
    end
  end

  module HTML
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
  end

  include Actions
  include Load
  include HTML

  def initialize(pipe = nil)
    @runtime_table = RuntimeTable.new
    @is_loaded = false
    pipe ? @pipe = pipe : @pipe = Pipe.new
  end

  def data_obj_name
    self.class.name.split("::").last
  end

  def attributes_of(group_name, options = {})
    @attribute_groups.attributes_of group_name, options
  end

  def set(attribute_values_by_name)
    @runtime_table.row << attribute_values_by_name
  end

  def method_missing(name, *args, &block)
    if @runtime_table.row.respond_to? name
      @runtime_table.row.send(name)
    else
      super
    end
  end

  def respond_to_missing?(name, include_private)
    if @runtime_table.row.respond_to? name then true else super end
  end

  private

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
