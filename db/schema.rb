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

ActiveRecord::Schema.define(version: 20150404085219) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alarms", force: true do |t|
    t.integer  "user_id"
    t.integer  "device_alarm_id"
    t.string   "alarm_name",      limit: 30
    t.string   "alarm_type",      limit: 10
    t.string   "src_loc_latlng",  limit: 60
    t.string   "dest_loc_latlng", limit: 60
    t.datetime "start_time"
    t.string   "trans_mode",      limit: 15
    t.string   "buddy_mobile",    limit: 20
    t.integer  "fence_dist"
    t.integer  "frequency"
    t.string   "alarm_status",    limit: 15
    t.datetime "reached_at"
    t.integer  "dist_travelled"
    t.float    "avg_speed"
    t.string   "loc_list",        limit: 250
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "alarms", ["user_id"], name: "index_alarms_on_user_id", using: :btree

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
    t.string   "mobile",         limit: 18
    t.string   "status",         limit: 12
    t.string   "other_value_1",  limit: 40
    t.string   "other_value_2",  limit: 60
    t.string   "other_value_3",  limit: 40
    t.string   "gcm_id",         limit: 260
  end

  add_index "devices", ["mobile"], name: "index_devices_on_mobile", using: :btree

  create_table "travels", force: true do |t|
    t.integer  "user_id"
    t.integer  "device_travel_id"
    t.string   "travel_name"
    t.string   "travel_type"
    t.string   "travel_from"
    t.string   "travel_to"
    t.datetime "travel_start_time"
    t.string   "travel_mode"
    t.string   "travel_buddy_list"
    t.integer  "travel_msg_freq"
    t.integer  "travel_alarm_distance"
    t.string   "travel_repeat"
    t.string   "travel_alarm_status"
    t.string   "travel_status"
    t.datetime "travel_eta"
    t.datetime "travel_next_start_time"
    t.string   "travel_milestone"
    t.string   "travel_intimation_list"
    t.integer  "travel_usage"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "travels", ["user_id"], name: "index_travels_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",            limit: 30
    t.string   "first_name",       limit: 20
    t.string   "last_name",        limit: 20
    t.integer  "age"
    t.string   "gender",           limit: 12
    t.text     "home_address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_gcm_id"
    t.string   "other_ids_2",      limit: 40
    t.string   "other_ids_3",      limit: 40
    t.string   "status",           limit: 12
    t.integer  "settings_app_ver"
    t.integer  "settings_web_ver"
    t.string   "country_code"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
