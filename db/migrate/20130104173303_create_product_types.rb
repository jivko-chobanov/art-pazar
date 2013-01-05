class CreateProductTypes < ActiveRecord::Migration
  def change
    create_table :product_types do |t|
      t.string   :tinyint_1, limit: 70, default: "", null: false
      t.string   :smallint_1, limit: 70, default: "", null: false
      t.string   :smallint_2, limit: 70, default: "", null: false
      t.string   :int_1, limit: 70, default: "", null: false
      t.string   :string_1, limit: 70, default: "", null: false
      t.string   :string_2, limit: 70, default: "", null: false
      t.string   :string_3, limit: 70, default: "", null: false
      t.string   :string_4, limit: 70, default: "", null: false
      t.string   :string_5, limit: 70, default: "", null: false
      t.string   :string_6, limit: 70, default: "", null: false
      t.string   :string_7, limit: 70, default: "", null: false
      t.string   :string_8, limit: 70, default: "", null: false
      t.string   :string_9, limit: 70, default: "", null: false
      t.string   :float_1, limit: 70, default: "", null: false
      t.string   :datetime_1, limit: 70, default: "", null: false
      t.string   :datetime_2, limit: 70, default: "", null: false
      t.string   :boolean_1, limit: 70, default: "", null: false
      t.string   :boolean_2, limit: 70, default: "", null: false
      t.string   :boolean_3, limit: 70, default: "", null: false
      t.string   :boolean_4, limit: 70, default: "", null: false
    end
  end
end
