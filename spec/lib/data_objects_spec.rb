describe "DataObjects" do
  let(:data_object_attribute_groups) { double put: nil }
  let(:loaded_data) { double }
  let(:pipe) { double }
  subject(:data_objects) do
    require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')
    new_data_objects
  end

  def new_data_objects
    data_objects = DataObjects.new(Products)

    data_objects.instance_variable_set :@attribute_groups, data_object_attribute_groups
    data_objects.instance_variable_set :@pipe, pipe
    data_objects.instance_variable_set :@loaded_data, loaded_data
    data_objects
  end

  def load_with_args(load_method, data_objects, args_for_load, expected_args_for_pipe)
    pipe.should_receive(:get).with(*expected_args_for_pipe)
      .and_return "content got by pipe"
    data_object_attribute_groups.stub(:attributes_of).with(args_for_load[:attribute_group], {})
      .and_return expected_args_for_pipe[1][:attributes]
    loaded_data.should_receive(:put).with "DataObjects", "content got by pipe"
    data_objects.send load_method, args_for_load
  end

  before :all do
    require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')
  end

  before do
    stub_const "AttributeGroups", Class.new
    stub_const "LoadedData", Class.new
    stub_const "Pipe", Class.new
    stub_const "Products", Class.new

    LoadedData.stub(:new) { loaded_data }
    Pipe.stub(:new) { pipe }
  end

  it "initializes with given pipe" do
    data_objects = DataObjects.new(Products, Pipe.new)
    expect(data_objects.instance_variable_get :@pipe).to eq pipe
  end

  it "gives attributes of attribute groups" do
    data_object_attribute_groups.stub(:attributes_of).with(:list, {}).and_return [:name, :price]
    expect(data_objects.attributes_of :list).to eq [:name, :price]

    data_object_attribute_groups.stub(:attributes_of).with(:list, add_suffix: "_p")
      .and_return [:name_p, :price_p]
    expect(data_objects.attributes_of :list, add_suffix: "_p").to eq [:name_p, :price_p]

    data_object_attribute_groups.stub(:attributes_of).with(:for_create, {})
      .and_return "attributes for create"
    expect(data_objects.loaded_data_hash_for_create).to eq(
      "DataObjects" => ["attributes for create"]
    )

    data_object_attribute_groups.stub(:attributes_of).with(:qqq, {}).and_raise RuntimeError
    expect { data_objects.attributes_of :qqq }.to raise_error RuntimeError
  end

  it "gives loaded data as hash" do
    expect { data_objects.loaded_data_hash }.to raise_error RuntimeError

    load_with_args :load_from_db, data_objects, {attribute_group: :list, limit: 2},
      [:loaded_data_obj_content, {attributes: [:name, :price], limit: 2}]

    loaded_data.stub(:to_hash).and_return "content got by pipe to hash"
    expect(data_objects.loaded_data_hash).to eq "content got by pipe to hash"
  end

  it "gives information about data" do
    expect(DataObjects.new(Products).data_obj_name).to eq "DataObjects"

    empty_data_objects = new_data_objects
    expect { empty_data_objects.loaded_empty_result? }.to raise_error RuntimeError
    expect(empty_data_objects.loaded?).to be_false

    load_with_args :load_from_db, empty_data_objects, {attribute_group: :list, limit: 0},
      [:loaded_data_obj_content, {attributes: [:name, :price], limit: 0}]

    loaded_data.stub(:empty?).and_return true
    expect(empty_data_objects.loaded?).to be_true
    expect(empty_data_objects.loaded_empty_result?).to be_true

    not_empty_data_objects = new_data_objects
    load_with_args :load_from_db, not_empty_data_objects, {attribute_group: :list, limit: 1},
      [:loaded_data_obj_content, {attributes: [:name, :price], limit: 1}]
    loaded_data.stub(:empty?).and_return false
    expect(not_empty_data_objects.loaded_empty_result?).to be_false
  end
  
  context "when loading" do
    it "from params" do
      load_with_args :load_from_params, data_objects,
        {attribute_group: :for_create, suffix: "_ok"},
        [:params, {attributes: [:name, :price], suffix: "_ok"}]
    end

    it "from database" do
      load_with_args :load_from_db, data_objects, {attribute_group: :list, limit: 1},
        [:loaded_data_obj_content, {attributes: [:name, :price], limit: 1}]
    end

    context "raises errors" do
      it "from database" do
        expect { data_objects.load_from_db limit: 1 }.to raise_error RuntimeError
      end

      it "from params" do
        expect { data_objects.load_from_params suffix: "_ok" }.to raise_error RuntimeError
      end
    end
  end

  it "creates" do
    attributes = {id: 12, name: "new name", price: 3.10}
    expect { new_data_objects.create attributes }.to raise_error RuntimeError

    data_object_attribute_groups.stub(:attributes_of).with(:for_create, {})
      .and_return [:valid_attribute1, :v_a2]
    expect { new_data_objects.create name: "valid" }.to raise_error RuntimeError

    attributes = {name: "new name", price: 3.10}
    data_object_attribute_groups.stub(:attributes_of).with(:for_create, {})
      .and_return attributes.keys
    pipe.should_receive(:put).with("DataObjects", attributes).and_return true
    expect(new_data_objects.create attributes).to be_true
  end

  it "updates" do
    attributes = {name: "new name", price: 3.10}
    expect { new_data_objects.update attributes }.to raise_error RuntimeError

    attributes = {id: 12, name: "new name", price: 3.10}
    pipe.should_receive(:put).with("DataObjects", attributes).and_return true
    expect(data_objects.update attributes).to be_true
  end

  context "when html is wanted" do
    it "presents one or more data objects" do
      data_objects = new_data_objects
      expect { data_objects.html }.to raise_error

      data_object_attribute_groups.stub(:attributes_of)
        .with(:list, {}).and_return "attributes of group list"
      pipe.should_receive(:get).with(
        :loaded_data_obj_content,
        {:limit => 5, :attributes => "attributes of group list"}
      ).and_return "content got by pipe"
      loaded_data.should_receive(:put).with "DataObjects", "content got by pipe"

      data_objects.load_from_db attribute_group: :list, limit: 5

      loaded_data.stub(:to_hash).with(no_args()).and_return "loaded data to hash"
      pipe.should_receive(:get).with(:html, data_by_type: "loaded data to hash")
        .and_return "html got by pipe"

      expect(data_objects.html).to eq "html got by pipe"
    end
    
    it "presents update interface" do
      load_with_args :load_from_db, data_objects, {attribute_group: :for_update, limit: 1},
        [:loaded_data_obj_content, {attributes: [:name, :category_id, :price], limit: 1}]

      loaded_data.stub(:to_hash).with(no_args()).and_return "loaded data to hash"
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
