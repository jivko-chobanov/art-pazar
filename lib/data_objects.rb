class DataObjects
  module Actions
    def create(attributes = nil)
      attributes = get_attributes_and_make_last_row_under_construction attributes
      attributes = check_attributes_for_create attributes

      success = put_to_pipe attributes
      @runtime_table.complete_the_row_under_construction(
        id: @pipe.get(:last_created_id, data_obj_name: data_obj_name)
      )
      success
    end

    def load_and_create
      load_from_params in_row_under_construction: true, attribute_group: :for_create
      create
    end

    def update(attributes = nil)
      if attributes.nil? then attributes = @runtime_table.row.to_hash end
      attributes = check_attributes_for_update attributes
      put_to_pipe attributes
    end

    def load_and_update
      load_from_params attribute_group: :for_update
      update
    end

    def delete(id_or_hash = nil)
      attribute_by_name = id_or_hash_or_nil_to_hash_for_delete id_or_hash
      if @pipe.delete data_obj_name, attribute_by_name
        @runtime_table.remove attribute_by_name
        true
      else
        false
      end
    end

    def load_and_delete
      load_from_params attribute_group: :id
      delete
    end

    private

    def get_attributes_and_make_last_row_under_construction(attributes)
      if attributes.nil?
        unless @runtime_table.has_row_under_construction?
          @runtime_table.make_last_row_under_construction
        end
        @runtime_table.row_under_construction.to_hash
      else
        @runtime_table.row_under_construction attributes
        attributes
      end
    end

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

    def check_attributes_for_update(attributes)
      if attributes.nil? then raise "Cannot update with nil attributes" end
      unless attributes.include? :id
        raise "Cannot update without an id"
      end
      attributes
    end

    def check_attributes_for_create(attributes)
      if attributes.nil? then raise "Cannot create with nil attributes" end
      if attributes.include?(:id) then raise "Cannot create with an id" end

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

      put_to_runtime_table Support.remove_suffix_from_keys(@pipe.get(:params, needs), suffix),
        needs
    end

    def load_from_db(needs)
      prepare_loading(needs)

      needs[:attributes] = attributes_of needs[:attribute_group]
      needs.delete :attribute_group

      needs[:data_obj_name] = data_obj_name

      put_to_runtime_table @pipe.get(:runtime_table_hashes, needs)
    end

    def loaded_to_hashes
      must_be_loaded_then do
        @runtime_table.to_hashes
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
        @pipe.get :html, data_by_type: {data_obj_name => @runtime_table.to_hashes}
      end
    end

    def html_for_update
      must_be_loaded_then do
        @pipe.get :html_for_update, data_by_type: @runtime_table.to_hashes
      end
    end

    def html_for_create
      @pipe.get :html_for_create, data_by_type: {data_obj_name => [attributes_of(:for_create)]}
    end
  end

  include Actions
  include Load
  include HTML
  include Enumerable

  def initialize(pipe = nil)
    @runtime_table = RuntimeTable.new
    @is_loaded = false
    pipe ? @pipe = pipe : @pipe = Pipe.new
  end

  def each(&block)
    @runtime_table.each &block
  end

  def data_obj_name
    self.class.name.split("::").last
  end

  def size
    @runtime_table.rows_count
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

  def put_to_runtime_table(rows_as_hashes_or_row_as_hash, options = {})
    if options.include? :in_row_under_construction
      @runtime_table.row_under_construction rows_as_hashes_or_row_as_hash
    else
      rows_as_hashes = to_rows_as_hashes rows_as_hashes_or_row_as_hash
      @runtime_table << rows_as_hashes
    end
  end

  def to_rows_as_hashes(rows_as_hashes_or_row_as_hash)
    if rows_as_hashes_or_row_as_hash.is_a? Array
      rows_as_hashes = rows_as_hashes_or_row_as_hash
    else
      rows_as_hashes = [rows_as_hashes_or_row_as_hash]
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
