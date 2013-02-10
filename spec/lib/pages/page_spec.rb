require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")

describe Page do
  let(:pipe) { double }
  subject(:any_page) { Page.new }

  before do
    stub_const "Pipe", Class.new
    stub_const "AnyPage", Class.new
  end

  context "loads data objects and makes html" do
    it "in two steps" do
      any_page.load
      any_page.stub(:pipe_name_of_txt_if_empty_content).and_return false
      expect(any_page.html { "the HTML" }).to eq "the HTML"
    end

    it "in one step" do
      any_page.stub(:load).with no_args
      any_page.stub(:pipe_name_of_txt_if_empty_content).and_return false
      any_page.stub(:html).with(no_args).and_return "the HTML"
      expect(any_page.load_and_get_html { "the HTML" }).to eq "the HTML"
    end
  end
 
  it "raises errors" do
    expect { any_page.accomplish }.to raise_error RuntimeError

    any_page.stub(:pipe_name_of_txt_if_empty_content).and_return false
    expect { any_page.html }.to raise_error RuntimeError

    expect(any_page.loaded?).to be_false
    any_page.load
    expect(any_page.loaded?).to be_true
    expect { any_page.load }.to raise_error RuntimeError
  end

  it "executes via #accomplish" do
    any_page.load
    expect { |block| any_page.accomplish(&block) }.to yield_control
  end

  it "displays msg if loaded empty content" do
    any_page.load
 
    any_page.stub(:pipe_name_of_txt_if_empty_content).and_return :no_content
    Pipe.should_receive(:new).and_return { pipe }
    pipe.should_receive(:get).with(:txt, txt: :no_content).and_return "No content."
    expect(any_page.html).to eq "No content."
  end
end
