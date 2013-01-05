class CreateProductsAdditionalInfos < ActiveRecord::Migration
  def change
    create_table :products_additional_infos do |t|
      t.integer  :type_id, null: false
      t.integer  :tinyint_1, precision: 3, limit: 1, null: true
      t.integer  :smallint_1, precision: 5, limit: 2, null: true
      t.integer  :smallint_2, precision: 5, limit: 2, null: true
      t.integer  :int_1, precision: 10, limit: 4, null: true
      t.string   :string_1, null: true
      t.string   :string_2, null: true
      t.string   :string_3, null: true
      t.string   :string_4, null: true
      t.string   :string_5, null: true
      t.string   :string_6, null: true
      t.string   :string_7, null: true
      t.string   :string_8, null: true
      t.string   :string_9, null: true
      t.float    :float_1, precision: 8, scale: 3, null: true
      t.datetime :datetime_1, null: true
      t.datetime :datetime_2, null: true
      t.boolean  :boolean_1, null: true
      t.boolean  :boolean_2, null: true
      t.boolean  :boolean_3, null: true
      t.boolean  :boolean_4, null: true
      t.boolean  :boolean_5, null: true
    end
  end
end

