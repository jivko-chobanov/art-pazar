describe "Action" do
  let(:pipe) { double }
  subject(:action) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    Action.new
  end

  before :all do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
  end

  before do
    stub_const "Pipe", Class.new
  end

  it "raises errors" do
    expect(action.loaded?).to be_false
    action.load
    expect(action.loaded?).to be_true
    expect { action.load }.to raise_error RuntimeError
  end
end
