describe "Operation" do
  let(:pipe) { double }
  subject(:operation) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    Operation.new
  end

  before do
    stub_const "Pipe", Class.new
    stub_const "Action", Class.new
  end

  it "raises errors" do
    operation.should_receive(:loaded?).and_return false
    expect { operation.accomplish }.to raise_error RuntimeError
  end

  context "loads and executes via #accomplish" do
    it "in two steps" do
      operation.should_receive(:loaded?).and_return true
      expect { |block| operation.accomplish(&block) }.to yield_control
    end

    it "in one step" do
      operation.should_receive(:load)
      operation.should_receive(:loaded?).and_return true
      expect { |block| operation.load_and_accomplish(&block) }.to yield_control
    end
  end
end
