class Product < ActiveRecord::Base
  belongs_to :product_type
  has_one :product_specification
end
