class RefreshTravelService
	require 'json'

	def call(params)

		connection_setting = {
	      :host      => "localhost",
	      :port      => 8642,
	      :user      => "kanopus",
	      :pass      => "k@nopu5",
	      :vhost     => "/",
	      :ssl       => false,
	      :heartbeat => 2,
	    }
    

		Rails.logger.debug "[AMQP] Refresh Travel params: #{params}"
		param_json = JSON.parse(params)
		Rails.logger.debug "[AMQP] Refresh Travel Json params: #{param_json.inspect}"

		consuming_device_id = param_json["to_id"]
		Rails.logger.info "[AMQP] Refresh Travel Consuming Id: #{consuming_device_id}"
		@device = Device.find(consuming_device_id)
		Rails.logger.info "[AMQP] Refresh Travel Mobile: #{@device.mobile}"
		send_data = {:service => "refreshtravel",
                     :data => params
		  			}.to_json

		Rails.logger.info "[AMQP] Refresh Travel Send Data: #{send_data}"

		# Send the refresh request to travelling mobile.
		if (!@device.nil?)
			route_key = "kanopus.kat.ttmresponse." + @device.mobile		

			Rails.logger.info "[AMQP] Refresh Travel RouteKey: #{route_key}"
	    	connection = AMQP.connect(connection_setting)
	    	Rails.logger.info "[AMQP] Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."

	        channel  ||= AMQP::Channel.new(connection)
	        exchange = channel.topic("ttmresponse", :durable => true)
	        exchange.publish(send_data, :routing_key => route_key, :persistent => true, :nowait => false) do 
	        	Rails.logger.info "[AMQP] Refresh Travel Message Published... Closing Connection..."
	        	connection.close
	        end

	    end

	end

end