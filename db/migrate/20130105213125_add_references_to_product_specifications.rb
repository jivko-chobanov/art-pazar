class AddReferencesToProductSpecifications < ActiveRecord::Migration
  def change
    change_table :product_specifications do |t|
      t.references :product_type
      t.references :product
    end
  end
end
