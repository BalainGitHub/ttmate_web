class UpdateTravelService
	require 'json'

	def call(params)

		connection_setting = {
	      :host      => "localhost",
	      :port      => 5672,
	      :user      => "kanopus",
	      :pass      => "k@nopu5",
	      :vhost     => "/",
	      :ssl       => false,
	      :heartbeat => 2,
	    }
    

	    Rails.logger.debug "[AMQP] UpdateTravel params: #{params}"
		param_json = JSON.parse(params)
		Rails.logger.debug "[AMQP] UpdateTravel Json params: #{param_json["travel"]}"

    	@travel = Travel.find(param_json["travel"]["id"])
		@travel[:user_id] = param_json["travel"]["user_id"]
		@travel[:device_travel_id] = param_json["travel"]["device_travel_id"]
		@travel[:travel_name] = param_json["travel"]["travel_name"]
		@travel[:travel_type] = param_json["travel"]["travel_type"]

		@travel[:travel_from] = param_json["travel"]["travel_from"]
		@travel[:travel_to] = param_json["travel"]["travel_to"]
		@travel[:travel_buddy_list] = param_json["travel"]["travel_buddy_list"]
		@travel[:travel_start_time] = param_json["travel"]["travel_start_time"]
		@travel[:travel_mode] = param_json["travel"]["travel_mode"]

		@travel[:travel_alarm_distance] = param_json["travel"]["travel_alarm_distance"]
		@travel[:travel_msg_freq] = param_json["travel"]["travel_msg_freq"]
		@travel[:travel_repeat] = param_json["travel"]["travel_repeat"]
		@travel[:travel_alarm_status] = param_json["travel"]["travel_alarm_status"]
		@travel[:travel_status] = param_json["travel"]["travel_status"]
		@travel[:travel_usage] = param_json["travel"]["travel_usage"]

		@travel[:travel_eta] = param_json["travel"]["travel_eta"]
		@travel[:travel_next_start_time] = param_json["travel"]["travel_next_start_time"]
		@travel[:travel_milestone] = param_json["travel"]["travel_milestone"]
		@travel[:travel_intimation_list] = param_json["travel"]["travel_intimation_list"]

		result = @travel.save

		@user = User.find(@travel.user_id)
		buddy_devices = Array.new

		Rails.logger.debug "[AMQP] UpdateTravel Starting to update tracks..."
		# Create travel-update exchange
		if @travel[:travel_buddy_list].length > 0
			buddy_nums = @travel[:travel_buddy_list].split(/,/)
			Rails.logger.debug "[AMQP] UpdateTravel Buddy Nums: #{buddy_nums.inspect}"
			buddy_nums.each do |bd_num|
				if bd_num.match(/^\+/)
				else
					device = Device.find(bd_num)
					if (!device.nil?)
						buddy_devices << device.mobile
					end
				end
			end
			Rails.logger.debug "[AMQP] UpdateTravel Buddy Devices: #{buddy_devices.inspect}"

			if buddy_devices.length > 0
				track_notice = Hash.new

				track_notice[:data_type] = "track_notice"
				# track_notice[:track_travel_name] = @travel.travel_name
				# track_notice[:track_notice_web_id] = "0"
				# track_notice[:track_notice_type] = "1"
				# track_notice[:track_type_id] = "0"
				track_notice[:buddy_web_id] = @travel.user_id
				track_notice[:travel_web_id] = @travel.id
				track_notice[:track_notice_method] = "0"
				# milestone = @travel.travel_milestone.split(/;/)
				# track_notice[:track_milestone] = milestone[-1]
				track_notice[:track_milestone] = @travel.travel_milestone
				track_notice[:track_from] = @travel.travel_from
				track_notice[:track_to] = @travel.travel_to
				track_notice[:track_notice_status] =  @travel.travel_status
				# track_notice[:track_travel_start_time] = @travel.travel_start_time

				send_track_data = {:service => "updatetravel-track",
								   :data => track_notice }.to_json

				Rails.logger.debug "[AMQP] UpdateTravel Send Track send_track_data: #{send_track_data.inspect}"
				#Prepare the connection and exchange
		    	connection = AMQP.connect(connection_setting)
		    	Rails.logger.info "[AMQP] Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."

		        channel  ||= AMQP::Channel.new(connection)
		        exchange = channel.topic("ttmresponse", :durable => true)

				buddy_devices.each_with_index do |buddy_mob, index|
					route_key = "kanopus.kat.ttmresponse." + buddy_mob
					Rails.logger.debug "[AMQP] UpdateTravel Send Track Data Route Key: #{route_key}"
					exchange.publish(send_track_data, :routing_key => route_key, :persistent => true, :nowait => false) do 
						if (index+1) == buddy_devices.size
							Rails.logger.info "[AMQP] UpdateTravel Message Published... Closing Connection..."
			        		connection.close
						end
					end

				end
				
			end
		end




	end

end