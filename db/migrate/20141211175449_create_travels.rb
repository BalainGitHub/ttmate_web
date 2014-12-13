class CreateTravels < ActiveRecord::Migration
  def change
    create_table :travels do |t|
      t.integer :user_id
      t.integer :device_travel_id
      t.string :travel_name
      t.string :travel_type
      t.string :travel_from
      t.string :travel_to
      t.datetime :travel_start_time
      t.string :travel_mode
      t.string :travel_buddy_list
      t.integer :travel_msg_freq
      t.integer :travel_alarm_distance
      t.string :travel_repeat
      t.string :travel_alarm_status
      t.string :travel_status
      t.datetime :travel_eta
      t.datetime :travel_next_start_time
      t.string :travel_milestone
      t.string :travel_intimation_list
      t.integer :travel_usage

      t.timestamps
    end
    add_index :travels, :user_id
  end
end
