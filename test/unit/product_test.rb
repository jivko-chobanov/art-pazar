require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  test 'database tables' do
    assert ActiveRecord::Base.connection.table_exists?(:products), 'db table exists'
  end

  test 'creating and changing' do
    assert Product.new.invalid?, 'new empty object is invalid'
    
    valid_product = Product.new products(:valid_product)

    assert_not_nil defined?(product.product_type), 'product belongs to a product_type'
    assert_not_nil defined?(product.product_specification), 'product has one product_specification'
  end
#   product_type = product.product_type
#   product_specification = product.product_specification
end
