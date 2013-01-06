class ProductSpecification < ActiveRecord::Base
  belongs_to :product, inverse_of: :product_specification
  belongs_to :product_type, inverse_of: :product_specification
end
