class GeneratorsController < ApplicationController
	include GeneratorsHelper
	def index
		
	end
	def create
		@input_code = params[:input_code]
		input = input_code(@user_input)
		generate_php_code(input)
		redirect_to action: "new"
	end
	def show
		@input_code = params[:input_code]
		send_file params[:input_code]
	end
	def new
		
	end
end
