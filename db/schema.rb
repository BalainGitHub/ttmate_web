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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140909065521) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "devices", force: true do |t|
    t.string   "brand",          limit: 15
    t.string   "device_name",    limit: 15
    t.string   "model",          limit: 15
    t.string   "build_id",       limit: 40
    t.string   "product",        limit: 20
    t.string   "imei",           limit: 60
    t.string   "android_id",     limit: 50
    t.string   "sdk_version",    limit: 15
    t.string   "os_release",     limit: 15
    t.integer  "os_incremental"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "mobile",       limit: 20
    t.string   "email",        limit: 30
    t.string   "first_name",   limit: 20
    t.string   "last_name",    limit: 20
    t.integer  "age"
    t.string   "gender",       limit: 12
    t.text     "home_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["mobile"], name: "index_users_on_mobile", unique: true, using: :btree

end
