class DevicesController < ApplicationController
	def index
		@users = Device.all
	end

	def show
		@user = Device.find(params[:id])
	end

	def new
		@user = Device.new
	end

	def edit
		@user = Device.find(params[:id])
	end
end
