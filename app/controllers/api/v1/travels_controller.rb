require 'gcm'

module Api
	module V1
		class TravelsController < ApplicationController
			respond_to :json
			skip_before_filter :verify_authenticity_token

			def index
				respond_with Travel.all
			end

			def show
				respond_with Travel.find(params[:id])
			end

			def new
				@travel = Travel.new
			end

			def create
				@travel = Travel.new(travel_params)
				result = @travel.save

				logger.debug "GCM Saved Travel: #{@travel.inspect}"
				#travel = @travel[0]
				#logger.debug "GCM Extracted Travel: #{travel.inspect}"

				if @travel[:travel_buddy_list].length > 0

					gcm = GCM.new("AIzaSyDFgUeHwZ67R5JbpJI9LC7vQdVC7pJ1zY8")
					registration_ids = Array.new
					logger.debug "GCM New Regn Ids: #{registration_ids.inspect}"

					buddy_nums = @travel[:travel_buddy_list].split(/,/)
					logger.debug "GCM Buddy Nums: #{buddy_nums.inspect}"
					buddy_nums.each do |bd_num|
						if bd_num.match(/^\+/)
						else
							user = User.find(bd_num)
							regn_id = user.user_gcm_id
							registration_ids << regn_id
							logger.debug "GCM Regn Ids: #{registration_ids.inspect}"
						end
					end

					if registration_ids.length > 0
						track_notice = Hash.new

						track_notice[:data_type] = "track_notice"
						track_notice[:track_travel_name] = @travel.travel_name
						track_notice[:track_notice_web_id] = "0"
						track_notice[:track_notice_type] = "1"
						track_notice[:track_type_id] = "0"
						track_notice[:buddy_web_id] = @travel.user_id
						track_notice[:travel_web_id] = @travel.id
						track_notice[:track_notice_method] = "0"
						track_notice[:track_milestone] = @travel.travel_milestone
						track_notice[:track_from] = @travel.travel_from
						track_notice[:track_to] = @travel.travel_to
						track_notice[:track_notice_status] = "New"
						track_notice[:track_travel_start_time] = travel_params[:travel_start_time];

						options = {data: track_notice }

						logger.debug "GCM Regn Ids: #{registration_ids.inspect}"
						logger.debug "GCM Options: #{options.inspect}"

						response = gcm.send(registration_ids, options)
						logger.debug "GCM Response: #{response.inspect}"

					end
				end

				respond_to do |format|
					if result
						format.json { render :status => 200,
           					   				 :json => { :success => true,
                     					  				:info => "TravelSaved",
                     					  				:data => @travel 
                     								  }
                      				}
					else 
						format.json { render :status => :unprocessable_entity,
            				   				 :json => { :success => false,
                        				  				:info => @travel.errors,
                        				  				:data => {} 
                        							  }
                        			}
					end
				end

			end

			def update
				@travel = Travel.find(params[:id])
				result = @travel.update_attributes(travel_params)

				if @travel[:travel_buddy_list].length > 0

					gcm = GCM.new("AIzaSyDFgUeHwZ67R5JbpJI9LC7vQdVC7pJ1zY8")
					registration_ids = Array.new
					logger.debug "GCM New Regn Ids: #{registration_ids.inspect}"

					buddy_nums = @travel[:travel_buddy_list].split(/,/)
					logger.debug "GCM Buddy Nums: #{buddy_nums.inspect}"
					buddy_nums.each do |bd_num|
						if bd_num.match(/^\+/)
						else
							user = User.find(bd_num)
							regn_id = user.user_gcm_id
							registration_ids << regn_id
							logger.debug "GCM Regn Ids: #{registration_ids.inspect}"
						end
					end

					if registration_ids.length > 0
						track_notice = Hash.new

						track_notice[:data_type] = "track_notice"
						#track_notice[:track_travel_name] = @travel.travel_name
						#track_notice[:track_notice_web_id] = "0"
						#track_notice[:track_notice_type] = "1"
						#track_notice[:track_type_id] = "0"
						track_notice[:buddy_web_id] = @travel.user_id
						track_notice[:travel_web_id] = @travel.id
						track_notice[:track_notice_method] = "0"
						milestone = @travel.travel_milestone.split(/;/)
						track_notice[:track_milestone] = milestone[-1]
						#track_notice[:track_from] = @travel.travel_from
						#track_notice[:track_to] = @travel.travel_to
						track_notice[:track_notice_status] = @travel.travel_status
						#track_notice[:track_travel_start_time] = travel_params[:travel_start_time];

						options = {data: track_notice }

						logger.debug "GCM Regn Ids: #{registration_ids.inspect}"
						logger.debug "GCM Options: #{options.inspect}"

						response = gcm.send(registration_ids, options)
						logger.debug "GCM Response: #{response.inspect}"

					end
				end

				respond_to do |format|
					if result
						format.json { render :status => 200,
           					   				 :json => { :success => true,
                     					  				:info => "TravelUpdated",
                     					  				:data => @travel 
                     								  }
                      				}
					else 
						format.json { render :status => :unprocessable_entity,
            				   				 :json => { :success => false,
                        				  				:info => @travel.errors,
                        				  				:data => {} 
                        							  }
                        			}
					end
				end

			end

			def destroy
				@travel = Travel.find(params[:id])
				@travel.destroy
				respond_to do |format|
					format.json { head :no_content }
				end
			end

			private
			def travel_params
    			params.require(:travel).permit(:id, :user_id, :device_travel_id, :travel_name, :travel_type, :travel_from, :travel_to, :travel_start_time, :travel_mode, :travel_buddy_list, :travel_alarm_distance, :travel_msg_freq, :travel_repeat, :travel_alarm_status, :travel_status, :travel_eta, :travel_next_start_time, :travel_milestone, :travel_intimation_list, :travel_usage)
  			end

		end
	end
end