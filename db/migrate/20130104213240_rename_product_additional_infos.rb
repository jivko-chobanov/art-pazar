class RenameProductAdditionalInfos < ActiveRecord::Migration
  def change
    rename_table :product_additional_infos, :product_specifications
  end
end
