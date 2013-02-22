module Main
  class ProductsInCart < DataObjects
    def initialize(pipe = nil)
      all_attributes = [:id, :buyer_id, :seller_id, :cart_id, :product_id, :quantity, :price, :status]
      @attribute_groups = AttributeGroups.new(
        list_for_admin: all_attributes,
        details: all_attributes,
        for_update: [:id, :quantity, :status],
        for_create: all_attributes.delete(:id),
      )
      super pipe
    end

    def class_abbreviation
      "PiC"
    end
  end
end
