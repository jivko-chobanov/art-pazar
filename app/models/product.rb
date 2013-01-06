class Product < ActiveRecord::Base
  belongs_to :product_type, inverse_of: :product
  has_one :product_specification, inverse_of: :product
end
