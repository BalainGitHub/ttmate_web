module Api
	module V1
		class DevicesController < ApplicationController
			respond_to :json
			#before_action :set_user, only: [:show, :edit, :update, :destroy]

			# The below two lines are required to skip verification of 
			# authenticity token when creating a user through json.
			#caches_page :index, :show  
 			skip_before_filter :verify_authenticity_token

			def mobile_search
				respond_with Device.find_by_mobile(params[:mobile])
			end

			def multi_mobile_search
				mobiles = params[:mobile_list].split(/,/)
				@devices = Device.where(:mobile => mobiles)

				respond_with @devices
			end

			
		end
	end
end