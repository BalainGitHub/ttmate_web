class UserRegistrationService
	require 'json'

	# def initialize(params)
	# 	Rails.logger.debug "[AMQP] Register params: #{params.inspect}"
	# 	@user = User.new(params)
	# 	@devices = @user.devices.build(user_params[:devices_attributes])
	# end

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
    

		Rails.logger.debug "[AMQP] Register params: #{params}"
		param_json = JSON.parse(params)
		Rails.logger.debug "[AMQP] Json params: #{param_json["user"]}"

		@user = User.new
		@user[:home_address] = param_json["user"]["home_address"]
		@user[:first_name] = param_json["user"]["first_name"]
		@user[:last_name] = param_json["user"]["last_name"]
		@user[:status] = param_json["user"]["status"]
		@user[:email] = param_json["user"]["email"]
		@user[:age] = param_json["user"]["age"]
		@user[:gender] = param_json["user"]["gender"]
		@user[:user_gcm_id] = param_json["user"]["user_gcm_id"]
		@user[:country_code] = param_json["user"]["country_code"]

		# @devices = @user.devices.build(param_json["user"]["devices_attributes"])

		@device = Device.new
		@device[:mobile] = param_json["user"]["devices_attributes"][0]["mobile"]
		@device[:brand] = param_json["user"]["devices_attributes"][0]["brand"]
		@device[:device_name] = param_json["user"]["devices_attributes"][0]["device_name"]
		@device[:model] = param_json["user"]["devices_attributes"][0]["model"]
		@device[:build_id] = param_json["user"]["devices_attributes"][0]["build_id"]
		@device[:product] = param_json["user"]["devices_attributes"][0]["product"]
		@device[:imei] = param_json["user"]["devices_attributes"][0]["imei"]
		@device[:android_id] = param_json["user"]["devices_attributes"][0]["android_id"]
		@device[:sdk_version] = param_json["user"]["devices_attributes"][0]["sdk_version"]
		@device[:os_release] = param_json["user"]["devices_attributes"][0]["os_release"]
		@device[:os_incremental] = param_json["user"]["devices_attributes"][0]["os_incremental"]
		@device[:status] = param_json["user"]["devices_attributes"][0]["status"]


		Rails.logger.debug "[AMQP] User: #{@user.inspect}"
		Rails.logger.debug "[AMQP] User Devise: #{@device.inspect}"


		app_set_max_id = AppSetting.maximum(:id)
		@app_setting = AppSetting.find(app_set_max_id)

		#===========================================
		# Check if user exists and active
		if User.exists?(:email => @user[:email])

			imei = @device[:imei]
			mobile = @device[:mobile]

			# Delete devices if imei or mobile already exisits.
			if Device.exists?(:imei => imei)
				del_device = Device.where(:imei => imei).first
				del_device.destroy
			end
			if Device.exists?(:mobile => mobile)
				del_device = Device.where(:mobile => mobile).first
				del_device.destroy
			end

			# Assign esisting user id to device user id.
			existing_user = User.where(:email => @user[:email]).first
			existing_user.app_settings_id = app_set_max_id
			existing_user.save

			@device[:user_id] = existing_user.id

			# Save only the device.
			devices_result = @device.save

			if devices_result
				send_data = {:success => true,
			  				:info => "DeviceAdded",
			  				:data => existing_user,
			  				:device => @device,
			  				:app_setting => @app_setting}.to_json
			else
				send_data = {:success => false,
			  				:info => @device.errors,
			  				:data => {} }.to_json
			end

			route_key = "kanopus.kat.register." + @device[:mobile]
			Rails.logger.info "[AMQP] Send Data: #{send_data}"

			# Rails.logger.info "[AMQP] Inside EventMachine..."
        	connection = AMQP.connect(connection_setting)
        	Rails.logger.info "[AMQP] Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."

	        channel  ||= AMQP::Channel.new(connection)
	        exchange = channel.topic("registration", :durable => true)
	        exchange.publish(send_data, :routing_key => route_key)

		else 
			imei = @device[:imei]
			mobile = @device[:mobile]

			# Delete devices if imei or mobile already exisits.
			if Device.exists?(:imei => imei) 
				del_device = Device.where(:imei => imei).first
				del_device.destroy
			end
			if Device.exists?(:mobile => mobile)
				del_device = Device.where(:mobile => mobile).first
				del_device.destroy
			end

			@user.status = "Registered"
			@user.app_settings_id = app_set_max_id

			result = @user.save
			@device[:user_id] = @user.id
			@device.save

			if devices_result
				send_data = {:success => true,
			  				:info => "Registered",
			  				:data => @user,
			  				:device => @device,
			  				:app_setting => @app_setting}.to_json
			else
				send_data = {:success => false,
			  				:info => @user.errors,
			  				:data => {} }.to_json
			end

			route_key = "kanopus.kat.register." + @device[:mobile]
			Rails.logger.info "[AMQP] Send Data: #{send_data}"

			# Rails.logger.info "[AMQP] Inside EventMachine..."
        	connection = AMQP.connect(connection_setting)
        	Rails.logger.info "[AMQP] Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."

	        channel  ||= AMQP::Channel.new(connection)
	        exchange = channel.topic("registration", :durable => true)
	        exchange.publish(send_data, :routing_key => route_key)

			
		end
	end
end