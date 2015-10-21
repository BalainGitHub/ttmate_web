class HomeController < ApplicationController

	def index
		@title = "loKatMe - Travel Tracker App"
		# @head = "kAT"
	end

	def help
		@title = "loKatMe - Help!"
	end

	def privacy
		@title = "loKatMe - Privacy"
	end
end
