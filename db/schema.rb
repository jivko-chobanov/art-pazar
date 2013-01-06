# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130106002336) do

  create_table "product_specifications", :force => true do |t|
    t.integer  "tinyint_1",       :limit => 2
    t.integer  "smallint_1",      :limit => 2
    t.integer  "smallint_2",      :limit => 2
    t.integer  "int_1"
    t.string   "string_1"
    t.string   "string_2"
    t.string   "string_3"
    t.string   "string_4"
    t.string   "string_5"
    t.string   "string_6"
    t.string   "string_7"
    t.string   "string_8"
    t.string   "string_9"
    t.float    "float_1"
    t.datetime "datetime_1"
    t.datetime "datetime_2"
    t.boolean  "boolean_1"
    t.boolean  "boolean_2"
    t.boolean  "boolean_3"
    t.boolean  "boolean_4"
    t.boolean  "boolean_5"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_type_id"
    t.integer  "product_id"
  end

  create_table "product_types", :force => true do |t|
    t.string   "tinyint_1",  :limit => 70, :default => "", :null => false
    t.string   "smallint_1", :limit => 70, :default => "", :null => false
    t.string   "smallint_2", :limit => 70, :default => "", :null => false
    t.string   "int_1",      :limit => 70, :default => "", :null => false
    t.string   "string_1",   :limit => 70, :default => "", :null => false
    t.string   "string_2",   :limit => 70, :default => "", :null => false
    t.string   "string_3",   :limit => 70, :default => "", :null => false
    t.string   "string_4",   :limit => 70, :default => "", :null => false
    t.string   "string_5",   :limit => 70, :default => "", :null => false
    t.string   "string_6",   :limit => 70, :default => "", :null => false
    t.string   "string_7",   :limit => 70, :default => "", :null => false
    t.string   "string_8",   :limit => 70, :default => "", :null => false
    t.string   "string_9",   :limit => 70, :default => "", :null => false
    t.string   "float_1",    :limit => 70, :default => "", :null => false
    t.string   "datetime_1", :limit => 70, :default => "", :null => false
    t.string   "datetime_2", :limit => 70, :default => "", :null => false
    t.string   "boolean_1",  :limit => 70, :default => "", :null => false
    t.string   "boolean_2",  :limit => 70, :default => "", :null => false
    t.string   "boolean_3",  :limit => 70, :default => "", :null => false
    t.string   "boolean_4",  :limit => 70, :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "name",                                              :null => false
    t.float    "price",                                             :null => false
    t.integer  "category_id",       :limit => 2,                    :null => false
    t.boolean  "published",                      :default => false, :null => false
    t.boolean  "sold",                           :default => false, :null => false
    t.integer  "width",             :limit => 2,                    :null => false
    t.integer  "height",            :limit => 2,                    :null => false
    t.integer  "depth",             :limit => 2,                    :null => false
    t.string   "short_description",              :default => "",    :null => false
    t.text     "info",                           :default => "",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_type_id"
  end

end
