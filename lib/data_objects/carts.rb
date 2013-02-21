module Main
  class Carts < DataObjects
    def initialize(pipe = nil)
      @attribute_groups = AttributeGroups.new(
        list_for_admin: [:id, :buyer_id, :seller_id, :status],
        details: [:id, :buyer_id, :seller_id, :status],
        for_update: [:id, :buyer_id, :seller_id, :status],
        for_create: [:buyer_id, :seller_id, :status],
      )
      super pipe
    end

    def class_abbreviation
      "C"
    end
  end
end
