describe "Page" do
  let(:pipe) { double }
  subject(:page) do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
    Page.new
  end

  before :all do
    require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")
  end

  before do
    stub_const "Pipe", Class.new
  end

  context "loads data objects and makes html" do
    it "in two steps" do
      page.load
      page.stub(:pipe_name_of_txt_if_empty_content).and_return false
      expect(page.html { "the HTML" }).to eq "the HTML"
    end

    it "in one step" do
      page.stub(:load).with no_args
      page.stub(:pipe_name_of_txt_if_empty_content).and_return false
      page.stub(:html).with(no_args).and_return "the HTML"
      expect(page.load_and_get_html { "the HTML" }).to eq "the HTML"
    end
  end
 
  it "raises errors" do
    expect { page.accomplish }.to raise_error RuntimeError

    page.stub(:pipe_name_of_txt_if_empty_content).and_return false
    expect { page.html }.to raise_error RuntimeError

    expect(page.loaded?).to be_false
    page.load
    expect(page.loaded?).to be_true
    expect { page.load }.to raise_error RuntimeError
  end

  context "loads and executes via #accomplish" do
    it "in two steps" do
      page.load
      expect { |block| page.accomplish(&block) }.to yield_control
    end

    it "in one step" do
      expect { |block| page.load_and_accomplish(&block) }.to yield_control
    end
  end

  it "displays msg if loaded empty content" do
    page.load
 
    page.stub(:pipe_name_of_txt_if_empty_content).and_return :no_content
    Pipe.should_receive(:new).and_return { pipe }
    pipe.should_receive(:get).with(:txt, txt: :no_content).and_return "No content."
    expect(page.html).to eq "No content."
  end
end
