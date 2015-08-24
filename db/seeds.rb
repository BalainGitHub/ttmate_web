# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

setting_data_hash = {'splash_time_out' => 1000,'alarm_notification_id' => 12345,'activated_notification_id_base' => 20000,'running_notification_id_base' => 30000,'track_notification_id_base' => 50000,'share_place_id_base' => 60000,'log_level' => 10,'log_file_dir' => "/sdcard/kat",'log_file_name' => "/sdcard/kat/tMateLog.log",'log_file_max_size' => 10000000,'log_prefix' => "travelTmateLogs:",'new_alarm_ping_timer' => 30000,'addr_upd_expiry_timer' => 60000,'dist_upd_expiry_timer' => 35000,'post_reg_expiry_timer' => 15000,'alrm_upd_expiry_timer' => 10000,'req_upd_expiry_timer' => 40000,'req_upd_short_expiry_timer' => 22000,'loc_man_clt_int_timer' => 5000,'loc_serv_interval' => 25,'dist_serv_interval' => 40,'alm_serv_interval' => 10,'app_expiry_days' => 30,'app_hard_coded_expiry' => "2015-06-30 23:59:59",'distance_to_complete' => 1000,'next_ping_divisor' => 5,'auto_ping_time' => "900",'activate_repeat_travel_window' => 120,'walk_speed_in_mps' => 1.4,'drive_speed_in_mps' => 17.0,'intimation_freq_buffer' => 2,'power_button_emergency_timer' => 3000,'emergency_button_click_count' => 3,'name_max_length' => 15,'currloc_radial_threshold' => 50,'msg_freq_high_limit' => 480,'msg_freq_low_limit' => 5,'alarm_dist_max_limit' => 50,'monit_service_run_freq' => 120,'travel_upd_expiry_timer' => 10000}
setting_data_json = setting_data_hash.to_json

app_settings = AppSetting.create(:version => "1", :setting_data => setting_data_json)
