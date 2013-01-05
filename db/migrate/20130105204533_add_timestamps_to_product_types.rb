class AddTimestampsToProductTypes < ActiveRecord::Migration
  def change
    change_table :product_types do |t|
      t.timestamps
    end
  end
end
