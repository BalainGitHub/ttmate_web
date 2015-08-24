class FeedbacksController < ApplicationController

	def index
		@feedbacks = Feedback.all
	end

	def show
		@feedback = Feedback.find(params[:id])
	end

	def new
		@feedback = Feedback.new
	end

	def edit
		@feedback = Feedback.find(params[:id])
	end

	def create
		logger.debug "New feedback - Params: #{params.inspect}"

		@feedback = Feedback.new(feedback_params)
		logger.debug "New feedback - Feedback: #{@feedback.inspect}"

		res = @feedback.save

		respond_to do |format|
			if res
				format.json { render :json => {:result => "Success" } }
			else 
				format.json { render :json => {:result => "Failure" } }
			end
		end

	end

	private
	def feedback_params
		params.require(:feedback).permit(:email, :name, :message)
	end


end
