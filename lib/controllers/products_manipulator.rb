class ProductsManipulator
  def initialize(phase, action)
    @phase, @action = phase, action
  end

  def html
    "Fill in fields: name, category_id, price"
  end
end
