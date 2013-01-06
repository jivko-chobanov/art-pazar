require 'test_helper'

class ProductTypeTest < ActiveSupport::TestCase
  test 'basics' do
    assert ActiveRecord::Base.connection.table_exists?(:product_types), 'db table exists'
  end

  test 'creating and changing' do
    assert ProductType.new.valid?, 'new object creation'

    product_type = ProductType.new

    assert_not_nil defined?(product_type.products), 'product_type has many products'
    assert_not_nil defined?(product_type.product_specifications), 'product_type has many product_specifications'
  end
end
