class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string   :name, null: false
      t.float    :price, precision: 5, scale: 2, null: false
      t.integer  :category, precision: 5, limit: 2, null: false
      t.boolean  :published, default: false, null: false
      t.boolean  :sold, default: false, null: false
      t.integer  :width, precision: 5, limit: 2, null: false
      t.integer  :height, precision: 5, limit: 2, null: false
      t.integer  :depth, precision: 5, limit: 2, null: false
      t.string   :short_description, default: "", null: false
      t.text     :info, default: "", null: false
    end
  end
end
