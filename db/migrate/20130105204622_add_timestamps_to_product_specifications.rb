class AddTimestampsToProductSpecifications < ActiveRecord::Migration
  def change
    change_table :product_specifications do |t|
      t.timestamps
    end
  end
end
