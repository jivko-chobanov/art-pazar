describe "Page" do
  let(:pipe) { double }
  subject(:page) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    Page.new
  end

  before do
    stub_const "Pipe", Class.new
    stub_const "Action", Class.new
  end

  context "loads data objects and makes html" do
    it "in two steps" do
      page.should_receive(:loaded?).and_return true
      page.should_receive(:pipe_name_of_txt_if_empty_content).and_return false
      expect(page.html { "the HTML" }).to eq "the HTML"
    end

    it "in one step" do
      page.should_receive(:load).with no_args
      page.should_receive(:html).with(no_args).and_return "the HTML"
      expect(page.load_and_get_html { "the HTML" }).to eq "the HTML"
    end
  end

  it "raises errors" do
    page.should_receive(:pipe_name_of_txt_if_empty_content).and_return false
    page.should_receive(:loaded?).and_return false
    expect { page.html }.to raise_error RuntimeError
  end

  it "displays msg if loaded empty content" do
    page.should_receive(:pipe_name_of_txt_if_empty_content).twice.and_return :no_content
    Pipe.should_receive(:new).and_return { pipe }
    pipe.should_receive(:get).with(:txt, txt: :no_content).and_return "No content."
    expect(page.html).to eq "No content."
  end
end
