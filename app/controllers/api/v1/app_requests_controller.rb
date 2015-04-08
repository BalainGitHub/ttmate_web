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

						gcm_response = gcm.send(registration_ids, options)
						logger.debug "GCM Response: #{gcm_response.inspect}"

					end
				end

				respond_to do |format|
					format.json { render :status => 200,
       					   				 :json => { :success => true,
                 					  				:info => "PlaceShared",
                 					  				:data => shareParams,
                 					  				:gcm_response => gcm_response
                 								  }
                  				}
				end
 			end
		end
	end
end