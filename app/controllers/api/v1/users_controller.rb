module Api
	module V1
		class UsersController < ApplicationController
			respond_to :json
			#before_action :set_user, only: [:show, :edit, :update, :destroy]

			# The below two lines are required to skip verification of 
			# authenticity token when creating a user through json.
			#caches_page :index, :show  
 			skip_before_filter :verify_authenticity_token

			def index
				respond_with User.all
			end

			def show
				respond_with User.find(params[:id])
			end

			def new
				@user = User.new
			end

			def create
				@user = User.new(user_params)

				result = @user.save

				respond_to do |format|
					if result
						format.json { render :status => 200,
           					   				 :json => { :success => true,
                     					  				:info => "Registered",
                     					  				:data => @user 
                     								  }
                      				}
					else 
						format.json { render :status => :unprocessable_entity,
            				   				 :json => { :success => false,
                        				  				:info => user.errors,
                        				  				:data => {} 
                        							  }
                        			}
					end
				end
			end

			def update
				respond_with User.update(params[:id], params[:user])
			end

			def destroy
				#respond_with User.destroy(params[:id])
				@user = User.find(params[:id])
				@user.destroy
				respond_to do |format|
					format.json { head :no_content }
				end
			end

			private
			def user_params
    			params.require(:user).permit(:mobile, :email, :first_name, :last_name, :age, :gender, :home_address, devices_attributes: [:brand, :device_name, :model, :build_id, :product, :imei, :android_id, :sdk_version, :os_release, :os_incremental])
  			end

		end
	end
end