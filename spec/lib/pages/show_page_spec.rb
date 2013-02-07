class Page
end

require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")

describe ShowPage do
  subject(:any_show_page) { AnyShowPage.new }

  before do
    stub_const "AnyShowPage", Class.new
  end
end
