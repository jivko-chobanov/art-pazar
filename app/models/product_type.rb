class ProductType < ActiveRecord::Base
  has_many :products, inverse_of: :product_type
  has_many :product_specifications, inverse_of: :product_type
end
