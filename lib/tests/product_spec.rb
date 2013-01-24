require_relative '../helper'
require_relative '../models/product'

class Product < ActiveRecord
  include ProductInstance
  extend ProductClass
end

describe Product do
  it 'abc' do
  end
end
