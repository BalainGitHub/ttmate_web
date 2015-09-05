if defined?(PhusionPassenger) # otherwise it breaks rake commands if you put this in an initializer
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    require 'eventmachine'
    require 'amqp'

    connection_setting = {
      :host      => "localhost",
      :port      => 5672,
      :user      => "kanopus",
      :pass      => "k@nopu5",
      :vhost     => "/",
      :ssl       => false,
      :heartbeat => 2,
    }

    if forked
      Rails.logger.info "[AMQP] Initializing amqp..."
      amqp_thread = Thread.new {
        failure_handler = lambda {
          Rails.logger.fatal Terminal.red("[AMQP] [FATAL] Could not connect to AMQP broker")
        }
        AMQP.start(:on_tcp_connection_failure => failure_handler)
      }
      amqp_thread.abort_on_exception = true
      sleep(0.15)

      EventMachine.next_tick do
        Rails.logger.info "[AMQP] Inside EventMachine for Create Travel..."
        connection = AMQP.connect(connection_setting)
        Rails.logger.info "[AMQP] Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."

        channel  ||= AMQP::Channel.new(connection)
        exchange = channel.topic("ttm", :durable => true)
        queue    = channel.queue("createtravel", :durable => true)
        
        queue.bind(exchange, :routing_key => "#.ttm.createtravel")

        channel.on_error do |ch, channel_close|
          Rails.logger.info "[AMQP] " + channel_close.reply_text
          connection.close { EventMachine.stop }
        end

        queue.subscribe do |metadata, payload|
          Rails.logger.info "[AMQP] Received a message for Createtravel: #{payload}"
          # Rails.logger.info "[AMQP] Metadata #{metadata.inspect}"
          CreateTravelService.new.call(payload)
        end
      end

      EventMachine.next_tick do
        Rails.logger.info "[AMQP] Inside EventMachine for Share Place..."
        connection = AMQP.connect(connection_setting)
        Rails.logger.info "[AMQP] Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."

        channel  ||= AMQP::Channel.new(connection)
        exchange = channel.topic("ttm", :durable => true)
        queue    = channel.queue("shareplace", :durable => true)
        
        queue.bind(exchange, :routing_key => "#.ttm.shareplace")

        channel.on_error do |ch, channel_close|
          Rails.logger.info "[AMQP] " + channel_close.reply_text
          connection.close { EventMachine.stop }
        end

        queue.subscribe do |metadata, payload|
          Rails.logger.info "[AMQP] Received a message for SharePlace: #{payload}"
          # Rails.logger.info "[AMQP] Metadata #{metadata.inspect}"

          SharePlaceService.new.call(payload)
        end
      end

      EventMachine.next_tick do
        Rails.logger.info "[AMQP] Inside EventMachine for Update Travel..."
        connection = AMQP.connect(connection_setting)
        Rails.logger.info "[AMQP] Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."

        channel  ||= AMQP::Channel.new(connection)
        exchange = channel.topic("ttm", :durable => true)
        queue    = channel.queue("updatetravel", :durable => true)
        
        queue.bind(exchange, :routing_key => "#.ttm.updatetravel")

        channel.on_error do |ch, channel_close|
          Rails.logger.info "[AMQP] " + channel_close.reply_text
          connection.close { EventMachine.stop }
        end

        queue.subscribe do |metadata, payload|
          Rails.logger.info "[AMQP] Received a message for UpdateTravel: #{payload}"
          # Rails.logger.info "[AMQP] Metadata #{metadata.inspect}"

          UpdateTravelService.new.call(payload)
        end
      end

      EventMachine.next_tick do
        Rails.logger.info "[AMQP] Inside EventMachine for Refresh Travel..."
        connection = AMQP.connect(connection_setting)
        Rails.logger.info "[AMQP] Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."

        channel  ||= AMQP::Channel.new(connection)
        exchange = channel.topic("ttm", :durable => true)
        queue    = channel.queue("refreshtravel", :durable => true)
        
        queue.bind(exchange, :routing_key => "#.ttm.refreshtravel")

        channel.on_error do |ch, channel_close|
          Rails.logger.info "[AMQP] " + channel_close.reply_text
          connection.close { EventMachine.stop }
        end

        queue.subscribe do |metadata, payload|
          Rails.logger.info "[AMQP] Received a message for RefreshTravel: #{payload}"
          # Rails.logger.info "[AMQP] Metadata #{metadata.inspect}"

          RefreshTravelService.new.call(payload)
        end
      end

      EventMachine.next_tick do
        Rails.logger.info "[AMQP] Inside EventMachine for Check App Settings..."
        connection = AMQP.connect(connection_setting)
        Rails.logger.info "[AMQP] Connected to AMQP broker. Running #{AMQP::VERSION} version of the gem..."

        channel  ||= AMQP::Channel.new(connection)
        exchange = channel.topic("ttm", :durable => true)
        queue    = channel.queue("checkappsettings", :durable => true)
        
        queue.bind(exchange, :routing_key => "#.ttm.checkappsettings")

        channel.on_error do |ch, channel_close|
          Rails.logger.info "[AMQP] " + channel_close.reply_text
          connection.close { EventMachine.stop }
        end

        queue.subscribe do |metadata, payload|
          Rails.logger.info "[AMQP] Received a message for CheckAppSettings: #{payload}"
          # Rails.logger.info "[AMQP] Metadata #{metadata.inspect}"

          CheckAppSettingsService.new.call(payload)
        end
      end

    end

  end
end