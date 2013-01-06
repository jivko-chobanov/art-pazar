class AddReferencesToProducts < ActiveRecord::Migration
  def change
    change_table :products do |t|
      t.references :product_type
    end
  end
end
