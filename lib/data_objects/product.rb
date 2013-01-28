module Main
  class Product
    AttributeGroup.new :list, [:name, :price], Main::Product

    def self.get_attributes(group_name)
      AttributeGroup.get_attributes group_name, Main::Product
    end
  end
end
