class Page
end

require __FILE__.sub("/spec/", "/").sub("_spec.rb", ".rb")

describe UpdateOrCreatePage do
  subject(:any_update_or_create_page) { AnyUpdateOrCreatePage.new }

  before do
    stub_const "Pipe", Class.new
    stub_const "AnyUpdateOrCreatePage", Class.new
  end
end
