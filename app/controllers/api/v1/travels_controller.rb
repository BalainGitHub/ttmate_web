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