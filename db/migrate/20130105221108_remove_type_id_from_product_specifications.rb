class RemoveTypeIdFromProductSpecifications < ActiveRecord::Migration
  def up
    remove_column :product_specifications, :type_id
  end

  def down
    add_column :product_specifications, :type_id, :integer, :null => false
  end
end
