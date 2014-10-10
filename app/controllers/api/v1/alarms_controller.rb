module Api
	module V1
		class AlarmsController < ApplicationController
			respond_to :json
			skip_before_filter :verify_authenticity_token

			def index
				respond_with Alarm.all
			end

			def show
				respond_with Alarm.find(params[:id])
			end

			def new
				@alarm = Alarm.new
			end

			def create
				@alarm = Alarm.new(alarm_params)

				result = @alarm.save

				respond_to do |format|
					if result
						format.json { render :status => 200,
           					   				 :json => { :success => true,
                     					  				:info => "AlarmSaved",
                     					  				:data => @alarm 
                     								  }
                      				}
					else 
						format.json { render :status => :unprocessable_entity,
            				   				 :json => { :success => false,
                        				  				:info => @alarm.errors,
                        				  				:data => {} 
                        							  }
                        			}
					end
				end

			end

			def update
				@alarm = Alarm.find(params[:id])
				result = @alarm.update_attributes(alarm_params)

				respond_to do |format|
					if result
						format.json { render :status => 200,
           					   				 :json => { :success => true,
                     					  				:info => "AlarmUpdated",
                     					  				:data => @alarm 
                     								  }
                      				}
					else 
						format.json { render :status => :unprocessable_entity,
            				   				 :json => { :success => false,
                        				  				:info => @alarm.errors,
                        				  				:data => {} 
                        							  }
                        			}
					end
				end

			end

			def destroy
				@alarm = Alarm.find(params[:id])
				@alarm.destroy
				respond_to do |format|
					format.json { head :no_content }
				end
			end

			private
			def alarm_params
    			params.require(:alarm).permit(:id, :user_id, :device_alarm_id, :alarm_name, :alarm_type, :src_loc_latlng, :dest_loc_latlng, :start_time, :trans_mode, :buddy_mobile, :fence_dist, :frequency, :alarm_status, :reached_at, :dist_travelled, :avg_speed, :loc_list)
  			end

		end
	end
end