require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")

describe ShowPage do
  let(:pipe) { double }
  subject(:any_show_page) { AnyShowPage.new }

  before do
    stub_const "Pipe", Class.new
    stub_const "AnyShowPage", Class.new
    AnyShowPage.send(:include, ShowPage)
  end

  context "loads products and makes html" do
    it "in two steps" do
      any_show_page.load_show_page
      expect(any_show_page.html_of_show_page { "the HTML" }).to eq "the HTML"
    end

    it "in one step" do
      any_show_page.stub(:load).with no_args
      any_show_page.stub(:html).with(no_args).and_return "the HTML"
      expect(any_show_page.load_and_get_html { "the HTML" }).to eq "the HTML"
    end
  end
 
  it "raises errors" do
    expect { any_show_page.html_of_show_page }.to raise_error RuntimeError

    expect(any_show_page.loaded?).to be_false
    any_show_page.load_show_page
    expect(any_show_page.loaded?).to be_true
    expect { any_show_page.load_show_page }.to raise_error RuntimeError
  end

  it "displays msg if loaded empty content" do
    any_show_page.load_show_page
 
    Pipe.should_receive(:new).and_return { pipe }
    pipe.should_receive(:get).with(:txt, txt: :no_content).and_return "No content."
    expect(any_show_page.html_of_show_page :no_content).to eq "No content."
  end
end
