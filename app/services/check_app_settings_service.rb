class CheckAppSettingsService
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
    

		Rails.logger.debug "[AMQP] AppSettings params: #{params}"
		param_json = JSON.parse(params)
		Rails.logger.debug "[AMQP] Json params: #{param_json["user_id"]}"

		appUserId = param_json["user_id"]

		appSysSettingsVersion = param_json["version"]
		deviceMobile = param_json["device_mobile"]

		@user = User.find(appUserId)
		Rails.logger.debug "[AMQP] User: #{@user.inspect}"
		Rails.logger.debug "[AMQP] User App Setting: #{@user.app_settings_id}"
		@app_setting = AppSetting.find(@user.app_settings_id)

		if @app_setting.version == appSysSettingsVersion
			send_data = {:success => true,
						 :info => "UpdatedVersion",
						 :service => "checkappsettings",
			  			 :app_setting => {}}.to_json
		else
			send_data = {:success => true,
						 :info => "NewVersion",
			  			 :service => "checkappsettings",
 		  				 :app_setting => @app_setting}.to_json
		end

		route_key = "kanopus.kat.ttmresponse." + deviceMobile
		Rails.logger.info "[AMQP] Send Data: #{send_data}"

		# Rails.logger.info "[AMQP] Inside EventMachine..."
    	connection = AMQP.connect(connection_setting)
    	Rails.logger.info "[AMQP] Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."

        channel  ||= AMQP::Channel.new(connection)
        exchange = channel.topic("ttmresponse", :durable => true)
        exchange.publish(send_data, :routing_key => route_key, :persistent => true, :nowait => false)

	end
end