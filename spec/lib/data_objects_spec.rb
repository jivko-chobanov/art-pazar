describe "DataObjects" do
  let(:data_object_attribute_groups) { double put: nil }
  let(:runtime_table) { double }
  let(:row) { double }
  let(:row_under_construction) { double }
  let(:pipe) { double }
  subject(:data_objects) do
    require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')
    new_data_objects
  end

  def new_data_objects
    data_objects = DataObjects.new

    data_objects.instance_variable_set :@attribute_groups, data_object_attribute_groups
    data_objects.instance_variable_set :@pipe, pipe
    data_objects.instance_variable_set :@runtime_table, runtime_table
    data_objects
  end

  def prep_load_from_db(data_objects, args_for_load, expected_args_for_pipe)
    data_object_attribute_groups.stub(:attributes_of).with(args_for_load[:attribute_group], {})
      .and_return expected_args_for_pipe[1][:attributes]
    pipe.should_receive(:get).with(*expected_args_for_pipe)
      .and_return ["content", "got by pipe"]
    runtime_table.should_receive(:<<).with ["content", "got by pipe"]
  end

  def prep_load_from_params(data_objects, args_for_load, expected_args_for_pipe)
    DataObjects.send(:define_method, :class_abbreviation) { "Pr" }
    data_object_attribute_groups.stub(:attributes_of)
      .with(args_for_load[:attribute_group], {suffix_to_be_added: "_Pr"})
      .and_return expected_args_for_pipe[1][:names]
    pipe.should_receive(:get).with(*expected_args_for_pipe)
      .and_return "content got by pipe"
    Support.should_receive(:remove_suffix_from_keys).with("content got by pipe", "_Pr")
      .and_return "content got by pipe"
    if args_for_load.include? :in_row_under_construction
      runtime_table.should_receive(:row_under_construction).with("content got by pipe")
    else
      runtime_table.should_receive(:<<).with ["content got by pipe"]
    end
  end

  def load_with_args(load_method, data_objects, args_for_load, expected_args_for_pipe)
    if load_method == :load_from_params
      prep_load_from_params data_objects, args_for_load, expected_args_for_pipe
    elsif load_method == :load_from_db
      prep_load_from_db data_objects, args_for_load, expected_args_for_pipe
    else
      raise "load method does not look like :load_from_..."
    end
    data_objects.send load_method, args_for_load
  end

  before :all do
    require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')
  end

  before do
    stub_const "AttributeGroups", Class.new
    stub_const "RuntimeTable", Class.new
    stub_const "Pipe", Class.new
    stub_const "Products", Class.new
    stub_const "Support", Class.new

    RuntimeTable.stub(:new) { runtime_table }
    Pipe.stub(:new) { pipe }
    runtime_table.stub(:row).with(no_args).and_return row
    runtime_table.stub(:row_under_construction).with(no_args).and_return row_under_construction
  end

  it "initializes with given pipe" do
    expect { DataObjects.new(Pipe.new) }.not_to raise_error RuntimeError
  end

  it "gives attributes of attribute groups" do
    data_object_attribute_groups.stub(:attributes_of).with(:list, {}).and_return [:name, :price]
    expect(data_objects.attributes_of :list).to eq [:name, :price]

    data_object_attribute_groups.stub(:attributes_of).with(:list, add_suffix: "_p")
      .and_return [:name_p, :price_p]
    expect(data_objects.attributes_of :list, add_suffix: "_p").to eq [:name_p, :price_p]

    data_object_attribute_groups.stub(:attributes_of).with(:qqq, {}).and_raise RuntimeError
    expect { data_objects.attributes_of :qqq }.to raise_error RuntimeError
  end

  it "gives loaded data as hash" do
    expect { data_objects.loaded_to_hashes }.to raise_error RuntimeError

    load_with_args :load_from_db, data_objects, {attribute_group: :list, limit: 2},
      [:runtime_table_hashes,
        {attributes: [:name, :price], limit: 2, data_obj_name: "DataObjects"}]

    runtime_table.stub(:to_hashes).and_return "content to hash"
    expect(data_objects.loaded_to_hashes).to eq "content to hash"
  end

  context "gives information about data" do
    it "data object name" do
      expect(DataObjects.new.data_obj_name).to eq "DataObjects"
    end

    it "num items" do
      runtime_table.should_receive(:rows_count).and_return 10
      expect(data_objects.size).to eq 10
    end

    it "checks with #loaded?, #loaded_empty_result?" do
      empty_data_objects = new_data_objects
      expect { empty_data_objects.loaded_empty_result? }.to raise_error RuntimeError
      expect(empty_data_objects.loaded?).to be_false

      load_with_args :load_from_db, empty_data_objects, {attribute_group: :list, limit: 0},
        [:runtime_table_hashes,
          {attributes: [:name, :price], limit: 0, data_obj_name: "DataObjects"}]

      runtime_table.stub(:empty?).and_return true
      expect(empty_data_objects.loaded?).to be_true
      expect(empty_data_objects.loaded_empty_result?).to be_true

      not_empty_data_objects = new_data_objects
      load_with_args :load_from_db, not_empty_data_objects, {attribute_group: :list, limit: 1},
        [:runtime_table_hashes,
          {attributes: [:name, :price], limit: 1, data_obj_name: "DataObjects"}]
      runtime_table.stub(:empty?).and_return false
      expect(not_empty_data_objects.loaded_empty_result?).to be_false
    end
  end

  context "loads" do
    it "from params" do
      load_with_args :load_from_params, data_objects,
        {attribute_group: :for_create},
        [:params, {names: [:name, :price]}]
    end

    it "from database" do
      load_with_args :load_from_db, data_objects, {attribute_group: :list, limit: 1},
        [:runtime_table_hashes,
          {attributes: [:name, :price], limit: 1, data_obj_name: "DataObjects"}]
    end

    it "many times from anywhere" do
      load_with_args :load_from_params, data_objects,
        {attribute_group: :for_update},
        [:params, {names: [:name, :price]}]
      load_with_args :load_from_params, data_objects,
        {attribute_group: :for_update},
        [:params, {names: [:name, :price]}]
      load_with_args :load_from_db, data_objects, {attribute_group: :for_update, limit: 1},
        [:runtime_table_hashes,
          {attributes: [:name, :price], limit: 1, data_obj_name: "DataObjects"}]
    end

    it "into row under construction" do
      load_with_args :load_from_params, data_objects,
        {in_row_under_construction: true, attribute_group: :for_update},
        [:params, {in_row_under_construction: true, names: [:name, :price]}]
    end

    context "raises errors" do
      it "when attribute_group is missing when loading from database" do
        expect { data_objects.load_from_db limit: 1 }.to raise_error RuntimeError
      end

      it "when attribute_group is missing when loading from params" do
        expect { data_objects.load_from_params any_key: :any_val }.to raise_error RuntimeError
      end
    end
  end

  it "sets and gets attribute values" do
    row.should_receive(:<<).with id: 5, name: "Jo"
    data_objects.set id: 5, name: "Jo"

    row.should_receive(:respond_to?).with(:id).and_return true
    row.should_receive(:id).and_return 5
    expect(data_objects.id).to eq 5

    row.should_receive(:respond_to?).with(:name).and_return true
    row.should_receive(:name).and_return "Jo"
    expect(data_objects.name).to eq "Jo"

    row.should_receive(:respond_to?).with(:qqq).and_return false
    expect { data_objects.qqq }.to raise_error NoMethodError

    row.should_receive(:respond_to?).with(:name).and_return true
    expect(data_objects.respond_to? :name).to be_true

    row.should_receive(:respond_to?).with(:qqq).and_return false
    expect(data_objects.respond_to? :qqq).to be_false
  end

  context "deletes one data object" do
    it "from given id or hash of one attribute by name" do
      pipe.should_receive(:delete).with("DataObjects", id: 13).and_return true
      expect(data_objects.delete 13).to be_true
      pipe.should_receive(:delete).with("DataObjects", other_id: 45).and_return true
      expect(data_objects.delete other_id: 45).to be_true

      expect { data_objects.delete one: 1, other: :any }.to raise_error RuntimeError
      expect { data_objects.delete "not id" }.to raise_error RuntimeError
    end
    
    it "from loaded data" do
      load_with_args :load_from_params, data_objects, {attribute_group: :id}, [:params, names: :id]
      row.should_receive(:id).with(no_args).and_return 15
      pipe.should_receive(:delete).with("DataObjects", id: 15).and_return true
      expect(data_objects.delete).to be_true
    end

    it "load and create in one step" do
      prep_load_from_params data_objects, {attribute_group: :id}, [:params, names: :id]
      row.should_receive(:id).with(no_args).and_return 15
      pipe.should_receive(:delete).with("DataObjects", id: 15).and_return true
      expect(data_objects.load_and_delete).to be_true
    end
  end

  context "creates" do
    context "from given attributes" do
      context "when wrong" do
        it "(id exists)" do
          attributes = {id: 12, name: "new name", price: 3.10}
          runtime_table.should_receive(:row_under_construction).with(attributes)
          expect { new_data_objects.create attributes }.to raise_error RuntimeError
        end

        it "(not match attribute group for_create)" do
          data_object_attribute_groups.stub(:attributes_of).with(:for_create, {})
            .and_return [:valid_attribute1, :v_a2]
          runtime_table.should_receive(:row_under_construction).with(name: "valid")
          expect { new_data_objects.create name: "valid" }.to raise_error RuntimeError
        end

        it "(no attributes are given)" do
          runtime_table.should_receive(:has_row_under_construction?).with(no_args).and_return false
          runtime_table.should_receive(:make_last_row_under_construction).with(no_args)
          runtime_table.should_receive(:row_under_construction).with(no_args).and_raise RuntimeError
          expect { new_data_objects.create }.to raise_error RuntimeError
        end
      end

      it "when ok" do
        attributes = {name: "new name", price: 3.10}
        runtime_table.should_receive(:row_under_construction).with(attributes)
        data_object_attribute_groups.stub(:attributes_of).with(:for_create, {})
          .and_return attributes.keys

        pipe.should_receive(:put).with("DataObjects", attributes).and_return true
        pipe.should_receive(:get).with(:last_created_id, data_obj_name: "DataObjects").and_return 24
        runtime_table.should_receive(:complete_the_row_under_construction).with id: 24
        expect(new_data_objects.create attributes).to be_true
      end
    end

    context "from loaded data" do
      it "in single row" do
        attributes = {name: "new name", price: 3.10}
        runtime_table.should_receive(:has_row_under_construction?).with(no_args)
          .and_return false
        runtime_table.should_receive(:make_last_row_under_construction).with(no_args)
        row_under_construction.should_receive(:to_hash).with(no_args).and_return attributes
        data_object_attribute_groups.should_receive(:attributes_of).with(:for_create, {})
          .and_return attributes.keys

        pipe.should_receive(:put).with("DataObjects", attributes).and_return true
        pipe.should_receive(:get).with(:last_created_id, data_obj_name: "DataObjects").and_return 24
        runtime_table.should_receive(:complete_the_row_under_construction).with id: 24
        expect(new_data_objects.create).to be_true
      end

      it "loaded in row under construction" do
        attributes = {name: "new name", price: 3.10}
        runtime_table.stub(:has_row_under_construction?).with(no_args).and_return true
        row_under_construction.should_receive(:to_hash).and_return attributes
        data_object_attribute_groups.stub(:attributes_of).with(:for_create, {})
          .and_return attributes.keys

        pipe.should_receive(:put).with("DataObjects", attributes).and_return true
        pipe.should_receive(:get).with(:last_created_id, data_obj_name: "DataObjects").and_return 24
        runtime_table.should_receive(:complete_the_row_under_construction).with id: 24
        expect(new_data_objects.create).to be_true
      end
    end

    it "loads and creates in one step" do
      attributes = {name: "new name", price: 3.10}
      prep_load_from_params data_objects, {in_row_under_construction: true, attribute_group: :for_create},
        [:params, {in_row_under_construction: true, names: attributes.keys}]

      runtime_table.stub(:has_row_under_construction?).with(no_args).and_return true
      row_under_construction.stub(:to_hash).with(no_args).and_return attributes
      data_object_attribute_groups.stub(:attributes_of).with(:for_create, {})
        .and_return attributes.keys
      pipe.should_receive(:put).with("DataObjects", attributes).and_return true
      pipe.should_receive(:get).with(:last_created_id, data_obj_name: "DataObjects").and_return 24
      runtime_table.should_receive(:complete_the_row_under_construction).with id: 24
      expect(new_data_objects.load_and_create).to be_true
    end
  end

  context "updates" do
    it "from given attributes" do
      attributes = {name: "new name", price: 3.10}
      expect { new_data_objects.update attributes }.to raise_error RuntimeError

      attributes = {id: 12, name: "new name", price: 3.10}
      pipe.should_receive(:put).with("DataObjects", attributes).and_return true
      expect(data_objects.update attributes).to be_true
    end

    it "raises error when no attributes are given" do
      runtime_table.should_receive(:row).with(no_args).and_raise RuntimeError
      expect { new_data_objects.update }.to raise_error RuntimeError
    end

    it "from loaded data" do
      attributes = {id: 14, name: "new name", price: 3.10}
      row.stub(:to_hash).with(no_args).and_return attributes
      data_object_attribute_groups.stub(:attributes_of).with(:for_update, {})
        .and_return attributes.keys
      pipe.should_receive(:put).with("DataObjects", attributes).and_return true
      expect(new_data_objects.update).to be_true
    end

    it "loads and updates in one step" do
      attributes = {id: 18, name: "new name", price: 3.10}
      prep_load_from_params data_objects, {attribute_group: :for_update},
        [:params, {names: attributes.keys}]
      row.stub(:to_hash).with(no_args).and_return attributes
      data_object_attribute_groups.stub(:attributes_of).with(:for_update, {})
        .and_return attributes.keys
      pipe.should_receive(:put).with("DataObjects", attributes).and_return true
      expect(new_data_objects.load_and_update).to be_true
    end
  end

  context "when html is wanted" do
    it "presents one or more data objects" do
      data_objects = new_data_objects
      expect { data_objects.html }.to raise_error

      data_object_attribute_groups.stub(:attributes_of)
        .with(:list, {}).and_return "attributes of group list"
      pipe.should_receive(:get).with(
        :runtime_table_hashes,
        {:limit => 5, :attributes => "attributes of group list", data_obj_name: "DataObjects"}
      ).and_return ["content", "got by pipe"]
      runtime_table.should_receive(:<<).with ["content", "got by pipe"]

      data_objects.load_from_db attribute_group: :list, limit: 5

      runtime_table.stub(:to_hashes).with(no_args).and_return "loaded data to hash"
      pipe.should_receive(:get).with(:html, data_by_type: {"DataObjects" => "loaded data to hash"})
        .and_return "html got by pipe"

      expect(data_objects.html).to eq "html got by pipe"
    end
    
    it "presents update interface" do
      load_with_args :load_from_db, data_objects, {attribute_group: :for_update, limit: 1},
        [:runtime_table_hashes,
          {attributes: [:name, :category_id, :price], limit: 1, data_obj_name: "DataObjects"}]

      runtime_table.stub(:to_hashes).with(no_args).and_return "loaded data to hash"
      pipe.should_receive(:get).with(:html_for_update, data_by_type: "loaded data to hash")
        .and_return "html got by pipe"
      expect(data_objects.html_for_update).to eq "html got by pipe"
    end

    it "presents create interface" do
      data_object_attribute_groups.stub(:attributes_of).with(:for_create, {}).and_return [:name, :category_id, :price]
      pipe.should_receive(:get).with(:html_for_create, data_by_type: { "DataObjects" => [[:name, :category_id, :price]] })
        .and_return "html got by pipe"
      expect(data_objects.html_for_create).to eq "html got by pipe"
    end
  end
end
