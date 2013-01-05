require 'test_helper'

class ProductSpecificationTest < ActiveSupport::TestCase
  test 'basics' do
    assert ActiveRecord::Base.connection.table_exists?(:product_specifications), 'db table exists'
  end

  test 'creating and changing' do
    assert ProductSpecification.new.valid?, 'new object creation'

    product_specification = ProductSpecification.new

    assert_not_nil defined?(product_specification.product), 'product_specification belongs to product'
  end
end
