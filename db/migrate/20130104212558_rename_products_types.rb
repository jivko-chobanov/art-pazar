class RenameProductsTypes < ActiveRecord::Migration
  def change
    rename_table :products_types, :product_types
  end
end
