describe "RuntimeTable" do
  subject(:runtime_table) do
    require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')
    RuntimeTable.new
  end
  let(:people_s_table) { RuntimeTable.new [{name: "John", age: 22}, {name: "Ana", age: 22}] }
  let(:johns_row) { RuntimeTable::Row.new name: "John", age: 22 }
  let(:row) { RuntimeTable::Row.new }

  before :all do
    require __FILE__.sub('/spec/', '/').sub('_spec.rb', '.rb')
  end

  before do
    stub_const "Support", Class.new
  end
  
  context "Row" do
    it "adds named values on initialization and gives values" do
      expect(johns_row.name).to eq "John"
      expect(johns_row.age).to eq 22
    end

    it "adds new named values" do
      row << {name: "John", age: 22}
      expect(row.name).to eq "John"
      expect(row.age).to eq 22
    end

    it "gives column names" do
      expect(johns_row.column_names).to eq [:name, :age]
    end

    it "#respond_to?" do
      expect(johns_row.respond_to? :name).to be_true
      expect(johns_row.respond_to? :qqq).to be_false
    end

    it "gives cells by column" do
      expect(johns_row.to_hash).to eq name: "John", age: 22
    end
  end

  context "Table" do
    context "can access the only row" do
      it "if 1 row" do
        single_row_table = RuntimeTable.new [{name: "John", age: 22}]
        expect(single_row_table.row).to be_a RuntimeTable::Row
      end

      it "if 0 rows creates empty Row" do
        zero_rows_table = RuntimeTable.new
        expect(zero_rows_table.row.to_hash).to eq({})
      end

      it "if many rows" do
        expect { people_s_table.row }.to raise_error RuntimeError
      end
    end

    it "is enumerable" do
      expect(people_s_table.map(&:name)).to eq ["John", "Ana"]
    end

    it "adds rows on initialization and gives them as hashes" do
      expect(people_s_table.to_hashes).to eq [{name: "John", age: 22}, {name: "Ana", age: 22}]
    end

    context "adds new rows" do
      it "when ok" do
        people_s_table << [{name: "Peg", age: 44}]
        expect(people_s_table.to_hashes).to eq(
          [{name: "John", age: 22}, {name: "Ana", age: 22}, {name: "Peg", age: 44}])
      end

      it "when different attributes - raises error" do
        expect { people_s_table << [{name: "Peg", age: 44, other: 2}] }.to raise_error RuntimeError
        expect { people_s_table << [{name: "Peg", other: 44}] }.to raise_error RuntimeError
        expect { people_s_table << [{name: "Peg"}] }.to raise_error RuntimeError
      end
    end

    it "removes using attribute_by_name" do
      people_s_table.remove name: "John"
      expect(people_s_table.rows_count).to eq 1

      people_s_table.remove age: 22
      expect(people_s_table.rows_count).to eq 0
    end

    context "works with row under construction" do
      it "checks if such exists" do
        expect(runtime_table.has_row_under_construction?).to be_false
        expect(people_s_table.has_row_under_construction?).to be_false

        runtime_table << [{name: "John", age: 22}]
        runtime_table.make_last_row_under_construction
        expect(runtime_table.has_row_under_construction?).to be_true
      end

      it "makes it from last row" do
        expect { runtime_table.make_last_row_under_construction }.to raise_error RuntimeError

        runtime_table << [{name: "John", age: 22}]
        runtime_table.make_last_row_under_construction

        expect { runtime_table.make_last_row_under_construction }.to raise_error RuntimeError

        runtime_table << [{name: "John", age: 22}]
        expect { runtime_table.make_last_row_under_construction }.to raise_error RuntimeError
      end

      it "makes it using given attributes by name" do
        runtime_table << [{name: "John", age: 22}]
        runtime_table << [{name: "Ana", age: 22}]
        runtime_table.row_under_construction name: "Peter"
        expect(runtime_table.has_row_under_construction?).to be_true
        expect(runtime_table.rows_count).to eq 2
      end

      it "gets it" do
        runtime_table << [{name: "John", age: 22}]
        old_row = runtime_table.row
        runtime_table.make_last_row_under_construction
        expect(runtime_table.row_under_construction).to be old_row
      end

      it "completes it" do
        runtime_table << [{name: "John", age: 22}]
        runtime_table.make_last_row_under_construction
        runtime_table.complete_the_row_under_construction id: 8
        expect(runtime_table.has_row_under_construction?).to be_false
        expect(runtime_table.empty?).to be_false
        expect(runtime_table.row.id).to eq 8
      end
    end

    it "checks emptines" do
      expect(people_s_table.empty?).to be_false
      expect(runtime_table.empty?).to be_true
    end

    it "gives column names" do
      expect(people_s_table.column_names).to eq [:name, :age]
    end

    it "gives rows count" do
      expect(people_s_table.rows_count).to eq 2
      expect(runtime_table.rows_count).to eq 0

      runtime_table << [{name: "John", age: 22}]
      expect(runtime_table.rows_count).to eq 1
    end
  end
end
