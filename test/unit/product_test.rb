require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test 'basics' do
    assert ActiveRecord::Base.connection.table_exists?(:products), 'db table exists'
  end

  test 'creating and changing' do
    assert Product.new.valid?, 'new object creation'

    product = Product.new

    assert_not_nil defined?(product.product_type), 'product belongs to a product_type'
    assert_not_nil defined?(product.product_specification), 'product has one product_specification'

    product_type = product.product_type
    product_specification = product.product_specification
  end
end
