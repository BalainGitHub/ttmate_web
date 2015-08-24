module Api
	module V1
		class AppRequestsController < ApplicationController
			respond_to :json
			#before_action :set_user, only: [:show, :edit, :update, :destroy]

			# The below two lines are required to skip verification of 
			# authenticity token when creating a user through json.
			#caches_page :index, :show  
 			skip_before_filter :verify_authenticity_token

 			def share_location
 				shareParams = Hash.new

 				shareParams[:data_type] = "share_place"
 				shareParams[:from_id] = params[:from_id]
 				shareParams[:to_id] = params[:to_id]
 				shareParams[:lat] = params[:lat]
 				shareParams[:lng] = params[:lng]

				if shareParams[:to_id] > 0

					gcm = GCM.new("AIzaSyDFgUeHwZ67R5JbpJI9LC7vQdVC7pJ1zY8")
					registration_ids = Array.new
					user = User.find(shareParams[:to_id])
					registration_ids << user.user_gcm_id
					logger.debug "GCM New Regn Ids: #{registration_ids.inspect}"

					if registration_ids.length > 0

						options = {data: shareParams }

						logger.debug "GCM Regn Ids: #{registration_ids.inspect}"
						logger.debug "GCM Options: #{options.inspect}"

						response = gcm.send(registration_ids, options)
						response_body = response[:body]
						success = response_body.split(/,/)[1].split(/:/)[1]
						failure = response_body.split(/,/)[2].split(/:/)[1]

						gcm_response = Hash.new
						gcm_response[:success] = success
						gcm_response[:failure] = failure

						logger.debug "GCM Response: #{gcm_response.inspect}"

					end
				end

				respond_to do |format|
					if success == "1"
						format.json { render :status => 200,
	       					   				 :json => { :success => true,
	                 					  				:info => "PlaceShared",
	                 					  				:data => gcm_response
	                 								  }
	                  				}
	                else 
	                	format.json { render :status => 200,
	       					   				 :json => { :success => false,
	                 					  				:info => "PlaceShareFailed",
	                 					  				:data => gcm_response
	                 								  }
	                  				}
	                end
				end
 			end

 			def push_sys_settings
 				sysSettings = Hash.new

 				# System Settings Version
 				sysSettings[:vers] = 1

				# Splash screen time out
				sysSettings[:splash_time_out] = 1000

				# Font file path
				sysSettings[:font_file] = "Gasalt-Black.ttf"
				        
				# Notification ID Base
				sysSettings[:alarm_notification_id] = 12345
				sysSettings[:activated_notification_id_base] = 20000
				sysSettings[:running_notification_id_base] = 30000
				sysSettings[:track_notification_id_base] = 50000
				sysSettings[:share_place_id_base] = 60000


				# Logging related
				sysSettings[:log_level] = 10
				sysSettings[:log_file_dir] = "/sdcard/kat"
				sysSettings[:log_file_name] = "/sdcard/kat/tMateLog.log"
				sysSettings[:log_file_max_size] = 10000000
				sysSettings[:log_prefix] = "travelTmateLogs:"


				# DB Related
				sysSettings[:db_version] = 21
				sysSettings[:db_name] = "ttmateDB"
				sysSettings[:db_pass] = "k@nopu5"

				# Google places search Key
				sysSettings[:places_key] = "AIzaSyCtt5GbVR9k04RWUKrazfp7ozGWqJU_92k"

				# Google Developer Project Id
				sysSettings[:google_dev_project_num] = "60501965273"

				# Cognalys lib related.
				sysSettings[:cognalys_app_id] = "f15544c50c724a97be34442"
				sysSettings[:cognalys_access_token] = "143cb5db051994c8f6f8e003d75ce748a49a3446"

				# RabbitMQ Related
				sysSettings[:rabbit_url] = "traveltmate.com"
				sysSettings[:rabbit_user] = "kanopus"
				sysSettings[:rabbit_pwd] = "k@nopu5"
				sysSettings[:rabbit_port] = 5672


				# Expiry Timers
				# Used in 1. Tmatemonitsequency:162 - startmonitsequence running frequency. 2.TmateUpdateBuddyService:73 - post delayed for runnableToUpdateBuddy
				sysSettings[:new_alarm_ping_timer] = 30000 
				# Expiry timer while getting address in GetAddressTask.java
				sysSettings[:addr_upd_expiry_timer] = 60000
				# Expiry timer while getting distance in GetDistanceTask.java
				sysSettings[:dist_upd_expiry_timer] = 35000
				# Expiry timer while sending registration data to tmate server / gcm regn
				sysSettings[:post_reg_expiry_timer] = 15000
				# Timer for Post Alarm Task. Should be a minimum value. Also used in patch register task.
				sysSettings[:alrm_upd_expiry_timer] = 10000
				# Expiry timer to get results from location update requests for locationclient and location manager in GetCurrLoctask.java
				sysSettings[:req_upd_expiry_timer] = 40000
				sysSettings[:req_upd_short_expiry_timer] = 22000
				# Timer for minimum update for location manager and location client request in GetCurrLoctask.java
				sysSettings[:loc_man_clt_int_timer] = 5000


				# Schedule intervals
				sysSettings[:loc_serv_interval] = 25
				sysSettings[:dist_serv_interval] = 40
				sysSettings[:alm_serv_interval] = 10


				# App Expiry limits
				sysSettings[:app_expiry_days] = 30
				sysSettings[:app_hard_coded_expiry] = "2015-06-30 23:59:59"

				# Travel calculation related.
				# Trigger distance to change alarm status to completed.
				sysSettings[:distance_to_complete] = 1000
				# Divisor to get the next ping
				sysSettings[:next_ping_divisor] = 5
				# Auto ping time in case of self track and buddy track.
				sysSettings[:auto_ping_time] = "900"
				# Time window to activate a repeating alarm in minutes
				sysSettings[:activate_repeat_travel_window] = 120
				# Speed in meters per second
				sysSettings[:walk_speed_in_mps] = 1.4
				sysSettings[:drive_speed_in_mps] = 17.0
				# Buffer time to check whether current is within intimation frequency in minutes
				sysSettings[:intimation_freq_buffer] = 2


				# Emergency Related
				sysSettings[:power_button_emergency_timer] = 3000
				sysSettings[:emergency_button_click_count] = 3

				# Validation Related.
				#Maximum allowed length for buddy and place and alarm name
				sysSettings[:name_max_length] = 15
				# Radial distance threshold for inserting current location into DB.
				sysSettings[:currloc_radial_threshold] = 50
				# Message frequency High threshold
				sysSettings[:msg_freq_high_limit] = 480
				# Message frequency Low threshold
				sysSettings[:msg_freq_low_limit] = 5
				# Maximum alarm distance limit
				sysSettings[:alarm_dist_max_limit] = 50

				respond_to do |format|
					format.json { render :status => 200,
       					   				 :json => { :setdata => sysSettings
                 								  }
                  				}
				end
 			end

		end
	end
end