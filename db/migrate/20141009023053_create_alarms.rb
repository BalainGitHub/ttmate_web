class CreateAlarms < ActiveRecord::Migration
  def change
    create_table :alarms do |t|
      t.integer :user_id
      t.integer :device_alarm_id
      t.string :alarm_name, limit: 30
      t.string :alarm_type, limit: 10
      t.string :src_loc_latlng, limit: 60
      t.string :dest_loc_latlng, limit: 60
      t.datetime :start_time
      t.string :trans_mode, limit: 15
      t.string :buddy_mobile, limit: 20
      t.integer :fence_dist
      t.integer :frequency
      t.string :alarm_status, limit: 15
      t.datetime :reached_at
      t.integer :dist_travelled
      t.float :avg_speed
      t.string :loc_list, limit: 250

      t.timestamps
    end
    add_index :alarms, :user_id
  end
end
