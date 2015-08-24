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

				app_set_max_id = AppSetting.maximum(:id)
				@app_setting = AppSetting.find(app_set_max_id)

				#===========================================
				# Check if user exists and active
				if User.exists?(:email => @user[:email])

					existing_user = User.where(:email => @user[:email]).first
					# existing_user.app_settings_id = app_set_max_id
					existing_user.update_attribute(:app_settings_id, app_set_max_id)

					@devices = @user.devices.build(user_params[:devices_attributes])
					imei = @devices.first[:imei]
					mobile = @devices.first[:mobile]
					@devices.first[:user_id] = existing_user.id
					logger.debug "New user - User Exists: @devices: #{@devices.inspect}"

					# Delete devices if imei or mobile already exisits.
					if Device.exists?(:mobile => mobile)
						avl_device = Device.where(:mobile => mobile).first
						logger.debug "New user - User Exists-Device Exists: Devices Attributes: #{user_params[:devices_attributes][0].inspect}"
						devices_result = avl_device.update_attributes(user_params[:devices_attributes][0])
						avl_device[:user_id] = existing_user.id
						# devices_result = avl_device.save
						logger.debug "New user - User Exists-Device Exists: avl_device: #{avl_device.inspect}"
					else
						# Save only the device.
						avl_device = @devices.first
						devices_result = avl_device.save

						logger.debug "New user - User Exists-Device Not Exists: avl_device: #{avl_device.inspect}"

					end

					respond_to do |format|
						if devices_result
							format.json { render :status => 200,
	           					   				 :json => { :success => true,
	                     					  				:info => "DeviceAdded",
	                     					  				:data => existing_user,
	                     					  				:device => avl_device,
	                     					  				:app_setting => @app_setting
	                     								  }
	                      				}
						else 
							format.json { render :status => :unprocessable_entity,
	            				   				 :json => { :success => false,
	                        				  				:info => avl_device.errors,
	                        				  				:data => {} 
	                        							  }
	                        			}
						end
					end

				else 
					imei = @user.devices.first[:imei]
					mobile = @user.devices.first[:mobile]

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

					respond_to do |format|
						if result
							format.json { render :status => 200,
	           					   				 :json => { :success => true,
	                     					  				:info => "Registered",
	                     					  				:data => @user,
	                     					  				:device => @user.devices.first,
	                     					  				:app_setting => @app_setting
	                     								  }
	                      				}
						else 
							format.json { render :status => :unprocessable_entity,
	            				   				 :json => { :success => false,
	                        				  				:info => @user.errors,
	                        				  				:data => {} 
	                        							  }
	                        			}
						end
					end
				end

				#respond_to do |format|
				#	format.json { render :status => 200,
       			#		   				 :json => { :success => true,
                #  					  				:info => "DeviceAssigned",
                #   					  				:data => @devices.first[:imei]
                #   								  }
                #   				}
                #end
	

			end

			def update
				## respond_with User.update(params[:id], params[:user])
				@user = User.find(params[:id])

				result = @user.update_attributes(:first_name => user_params[:first_name], :last_name => user_params[:last_name], :age => user_params[:age], :gender => user_params[:gender], :user_gcm_id => user_params[:user_gcm_id], :devices_attributes => user_params[:devices_attributes])

				respond_to do |format|
					if result
						format.json { render :status => 200,
           					   				 :json => { :success => true,
                     					  				:info => "UserUpdated",
                     					  				:data => @user,
                     					  				:device => @user.devices.first
                     								  }
                      				}
					else 
						format.json { render :status => :unprocessable_entity,
            				   				 :json => { :success => false,
                        				  				:info => @user.errors,
                        				  				:data => {} 
                        							  }
                        			}
					end
				end
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
    			params.require(:user).permit(:email, :first_name, :last_name, :age, :gender, :home_address, :user_gcm_id, :country_code, 
    										 devices_attributes: [:mobile, :brand, :device_name, :model, :build_id, :product, :imei, :android_id, :sdk_version, :os_release, :os_incremental],
    										 app_setting_attributes: [:id, :version, :setting_data])
  			end

		end
	end
end