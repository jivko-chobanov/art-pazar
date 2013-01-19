class ProductType < ActiveRecord::Base
  has_many :products
  has_many :product_specifications
end
