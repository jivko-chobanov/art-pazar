class Product < ActiveRecord::Base
  belongs_to :product_type
  has_one :product_specification

  validates :name, :price, :category_id, :width, :height, :depth, :product_type_id, presence: true
  validates :price, :width, :height, :depth, numericality: { greater_than_or_equal_to: 0 }
  validates :width, :height, :depth, numericality: { only_integer: true }
  validates_presence_of :product_type
end
