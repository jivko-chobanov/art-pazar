class RenameProductsAdditionalInfos < ActiveRecord::Migration
  def change
    rename_table :products_additional_infos, :product_additional_infos
  end
end
